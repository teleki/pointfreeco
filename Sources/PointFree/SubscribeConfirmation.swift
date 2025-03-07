import Dependencies
import Either
import EmailAddress
import Foundation
import HttpPipeline
import Models
import PointFreeDependencies
import PointFreePrelude
import PointFreeRouter
import Prelude
import Stripe
import Tuple
import Views

public let subscribeConfirmation:
  M<Tuple3<Pricing.Lane, SubscribeConfirmationData, Stripe.Coupon?>> =
    redirectActiveSubscribers
    <<< validateReferralCode
    <| writeStatus(.ok)
    >=> map(lower)
    >>> respond(
      view: Views.subscriptionConfirmation,
      layoutData: {
        (
          lane: Pricing.Lane,
          subscribeData: SubscribeConfirmationData,
          coupon: Stripe.Coupon?,
          referrer: User?
        ) in
        @Dependency(\.episodes) var episodes
        @Dependency(\.envVars) var envVars
        @Dependency(\.stripe.js) var js

        return SimplePageLayoutData(
          data: (
            lane,
            subscribeData,
            coupon,
            referrer,
            stats(forEpisodes: episodes()),
            js,
            envVars.stripe.publishableKey
          ),
          extraStyles: extraSubscriptionLandingStyles,
          style: .base(.some(.minimal(.black))),
          title: referrer == nil
            ? "Subscribe to Point-Free"
            : "Subscribe and get a free month of Point-Free"
        )
      }
    )

private func validateReferralCode(
  middleware: @escaping M<Tuple4<Pricing.Lane, SubscribeConfirmationData, Stripe.Coupon?, User?>>
) -> M<Tuple3<Pricing.Lane, SubscribeConfirmationData, Stripe.Coupon?>> {
  @Dependency(\.database) var database
  @Dependency(\.stripe) var stripe

  return { conn in
    @Dependency(\.currentUser) var currentUser

    let (lane, subscribeData, coupon) = lower(conn.data)
    guard
      let referralCode = subscribeData.referralCode
    else {
      return middleware(
        conn.map(
          const(lane .*. subscribeData .*. coupon .*. nil .*. unit)
        )
      )
    }

    guard lane == .personal else {
      return conn
        |> redirect(
          to: .subscribeConfirmation(
            lane: lane,
            billing: subscribeData.billing,
            isOwnerTakingSeat: subscribeData.isOwnerTakingSeat,
            teammates: subscribeData.teammates,
            useRegionalDiscount: subscribeData.useRegionalDiscount
          ),
          headersMiddleware: flash(.error, "Referrals are only valid for personal subscriptions.")
        )
    }

    guard currentUser?.referrerId == nil else {
      return conn
        |> redirect(
          to: .subscribeConfirmation(
            lane: lane,
            billing: subscribeData.billing,
            isOwnerTakingSeat: subscribeData.isOwnerTakingSeat,
            teammates: subscribeData.teammates,
            useRegionalDiscount: subscribeData.useRegionalDiscount
          ),
          headersMiddleware: flash(.error, "Referrals are only valid for first-time subscribers.")
        )
    }

    if let coupon = coupon {
      return conn |> redirect(to: .discounts(code: coupon.id, subscribeData.billing))
    }

    return EitherIO {
      let referrer = try await database.fetchUser(referralCode: referralCode)
      let subscription = try await database.fetchSubscription(ownerID: referrer.id)
      let stripeSubscription =
        try await stripe
        .fetchSubscription(subscription.stripeSubscriptionId)
      guard stripeSubscription.isCancellable else { throw unit }
      return referrer
    }
    .run
    .flatMap(
      either(
        const(
          conn
            |> redirect(
              to: .subscribeConfirmation(
                lane: lane,
                billing: subscribeData.billing,
                isOwnerTakingSeat: subscribeData.isOwnerTakingSeat,
                teammates: subscribeData.teammates,
                useRegionalDiscount: subscribeData.useRegionalDiscount
              ),
              headersMiddleware: flash(.error, "Invalid referral code.")
            )
        ),
        { referrer in
          conn.map(
            const(lane .*. subscribeData .*. coupon .*. referrer .*. unit)
          ) |> middleware
        }
      )
    )
  }
}

public let discountSubscribeConfirmation =
  fetchAndValidateCoupon
  <| map(over3(Optional.some))
  >>> pure
  >=> subscribeConfirmation

private let fetchAndValidateCoupon:
  MT<
    Tuple3<Pricing.Lane, SubscribeConfirmationData, Stripe.Coupon.ID?>,
    Tuple3<Pricing.Lane, SubscribeConfirmationData, Stripe.Coupon>
  > =
    filterMap(
      over3(fetchCoupon) >>> sequence3 >>> map(require3),
      or: redirect(
        to: .subscribeConfirmation(
          lane: .personal,
          useRegionalDiscount: false
        ),
        headersMiddleware: flash(.error, couponError)
      )
    )
    <<< filter(
      get3 >>> \.valid,
      or: redirect(
        to: .subscribeConfirmation(
          lane: .personal,
          useRegionalDiscount: false
        ),
        headersMiddleware: flash(.error, couponError)
      )
    )

private let couponError = "That coupon code is invalid or has expired."

private func fetchCoupon(_ couponId: Stripe.Coupon.ID?) -> IO<Stripe.Coupon?> {
  return IO {
    @Dependency(\.envVars) var envVars
    @Dependency(\.stripe) var stripe
    guard let couponId, couponId != envVars.regionalDiscountCouponId else { return nil }
    return try? await stripe.fetchCoupon(couponId)
  }
}

func redirectActiveSubscribers<A>(
  middleware: @escaping Middleware<StatusLineOpen, ResponseEnded, A, Data>
) -> Middleware<StatusLineOpen, ResponseEnded, A, Data> {
  return { conn in
    @Dependency(\.subscriberState) var subscriberState
    guard subscriberState.isNonSubscriber else {
      return conn
        |> redirect(
          to: .account(),
          headersMiddleware: flash(.notice, "You are already subscribed to Point-Free!")
        )
    }
    return middleware(conn)
  }
}
