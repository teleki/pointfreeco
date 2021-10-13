import Foundation
import HttpPipeline
import Models
import PointFreePrelude
import PointFreeRouter
import Prelude
import Tuple

public func giftsMiddleware(
  _ conn: Conn<StatusLineOpen, Tuple4<User?, Route, SubscriberState, Gifts>>
) -> IO<Conn<ResponseEnded, Data>> {

  let (user, route, subscriberState, gift) = lower(conn.data)

  switch gift {
  case .create:
    return conn
    |> writeStatus(.ok)
    >=> respond(html: "TODO")

  case .index:
    return conn.map(const(user .*. route .*. subscriberState .*. unit))
    |> giftsIndexMiddleware

  case let .plan(plan):
    return conn.map(const(plan .*. user .*. route .*. subscriberState .*. unit))
    |> giftPaymentMiddleware
  }
}