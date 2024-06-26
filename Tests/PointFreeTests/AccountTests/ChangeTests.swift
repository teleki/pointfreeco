import Dependencies
import Either
import HttpPipeline
import Models
import PointFreePrelude
import PointFreeTestSupport
import Prelude
import SnapshotTesting
import XCTest

@testable import PointFree
@testable import Stripe

#if !os(Linux)
  import WebKit
#endif

final class ChangeTests: TestCase {
  override func setUp() async throws {
    try await super.setUp()
    //SnapshotTesting.record = true
  }

  @MainActor
  func testChangeRedirect() async throws {
    #if !os(Linux)
      await withDependencies {
        $0.stripe.fetchSubscription = { _ in .individualMonthly }
      } operation: {
        let conn = connection(
          from: request(to: .account(.subscription(.change(.show))), session: .loggedIn))
        await assertSnapshot(matching: await siteMiddleware(conn), as: .conn)
      }
    #endif
  }

  @MainActor
  func testChangeUpdateUpgradeIndividualPlan() async throws {
    #if !os(Linux)
      await withDependencies {
        $0.stripe.fetchSubscription = { _ in .individualMonthly }
        $0.stripe.invoiceCustomer = { _ in
          XCTFail()
          return .mock(charge: .right(.mock))
        }
      } operation: {
        let conn = connection(
          from: request(
            to: .account(.subscription(.change(.update(.individualYearly)))), session: .loggedIn))
        await assertSnapshot(matching: await siteMiddleware(conn), as: .conn)
      }
    #endif
  }

  @MainActor
  func testChangeUpdateDowngradeIndividualPlan() async throws {
    #if !os(Linux)
      await withDependencies {
        $0.stripe.fetchSubscription = { _ in .individualYearly }
        $0.stripe.invoiceCustomer = { _ in
          XCTFail()
          return .mock(charge: .right(.mock))
        }
      } operation: {
        let conn = connection(
          from: request(
            to: .account(.subscription(.change(.update(.individualMonthly)))), session: .loggedIn))
        await assertSnapshot(matching: await siteMiddleware(conn), as: .conn)
      }
    #endif
  }

  @MainActor
  func testChangeUpdateUpgradeTeamPlan() async throws {
    #if !os(Linux)
      await withDependencies {
        $0.stripe.fetchSubscription = { _ in .teamMonthly }
        $0.stripe.invoiceCustomer = { _ in
          XCTFail()
          return .mock(charge: .right(.mock))
        }
      } operation: {
        let conn = connection(
          from: request(
            to: .account(.subscription(.change(.update(.teamYearly)))), session: .loggedIn))
        await assertSnapshot(matching: await siteMiddleware(conn), as: .conn)
      }
    #endif
  }

  @MainActor
  func testChangeUpdateDowngradeTeamPlan() async throws {
    #if !os(Linux)
      await withDependencies {
        $0.stripe.fetchSubscription = { _ in .individualYearly }
        $0.stripe.invoiceCustomer = { _ in
          XCTFail()
          return .mock(charge: .right(.mock))
        }
      } operation: {
        let conn = connection(
          from: request(
            to: .account(.subscription(.change(.update(.teamMonthly)))), session: .loggedIn))
        await assertSnapshot(matching: await siteMiddleware(conn), as: .conn)
      }
    #endif
  }

  @MainActor
  func testChangeUpdateAddSeatsIndividualPlan() async throws {
    #if !os(Linux)
      await withDependencies {
        $0.stripe.fetchSubscription = { _ in .individualMonthly }
      } operation: {
        let conn = connection(
          from: request(
            to: .account(.subscription(.change(.update(.teamMonthly)))), session: .loggedIn))
        await assertSnapshot(matching: await siteMiddleware(conn), as: .conn)
      }
    #endif
  }

  @MainActor
  func testChangeUpgradeIndividualMonthlyToTeamYearly() async throws {
    #if !os(Linux)
      await withDependencies {
        $0.stripe.fetchSubscription = { _ in .individualMonthly }
      } operation: {
        let conn = connection(
          from: request(
            to: .account(.subscription(.change(.update(.teamYearly)))), session: .loggedIn))
        await assertSnapshot(matching: await siteMiddleware(conn), as: .conn)
      }
    #endif
  }

  @MainActor
  func testChangeUpdateAddSeatsTeamPlan() async throws {
    #if !os(Linux)
      await withDependencies {
        $0.stripe.fetchSubscription = { _ in .teamMonthly }
      } operation: {
        var pricing = Pricing.teamMonthly
        pricing.quantity += 4

        let conn = connection(
          from: request(to: .account(.subscription(.change(.update(pricing)))), session: .loggedIn))
        let result = await siteMiddleware(conn)
        await assertSnapshot(matching: result, as: .conn)
      }
    #endif
  }

  @MainActor
  func testChangeUpdateRemoveSeats() async throws {
    #if !os(Linux)
      await withDependencies {
        $0.stripe.fetchSubscription = { _ in .teamMonthly }
        $0.stripe.invoiceCustomer = { _ in
          XCTFail()
          return .mock(charge: .right(.mock))
        }
      } operation: {
        var pricing = Pricing.teamMonthly
        pricing.quantity -= 1

        let conn = connection(
          from: request(to: .account(.subscription(.change(.update(pricing)))), session: .loggedIn))

        await assertSnapshot(matching: await siteMiddleware(conn), as: .conn)
      }
    #endif
  }

  @MainActor
  func testChangeUpdateRemoveSeatsInvalidNumber() async throws {
    #if !os(Linux)
      var subscription = Stripe.Subscription.mock
      subscription.plan = .teamYearly
      subscription.quantity = 5

      await withDependencies {
        $0.database.fetchSubscriptionTeammatesByOwnerId = { _ in [.teammate, .teammate] }
        $0.database.fetchTeamInvites = { _ in [.mock, .mock] }
        $0.stripe.fetchSubscription = { _ in subscription }
      } operation: {
        var pricing = Pricing.teamYearly
        pricing.quantity = 3

        let conn = connection(
          from: request(to: .account(.subscription(.change(.update(pricing)))), session: .loggedIn)
        )

        await assertSnapshot(matching: await siteMiddleware(conn), as: .conn)
      }
    #endif
  }
}
