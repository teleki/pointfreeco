import Foundation

extension Episode {
  public static let ep154_asyncRefreshableTCA = Episode(
    blurb: """
      The Composable Architecture does not yet support any of the fancy new concurrency features from WWDC this year, so is it possible to interact with async/await APIs like `.refreshable`? Not only is it possible, but it can be done without any changes to the core library.
      """,
    codeSampleDirectory: "0154-refreshable-pt2",
    exercises: _exercises,
    id: 154,
    length: 34 * 60 + 52,
    permission: .free,
    publishedAt: Date(timeIntervalSince1970: 1_627_275_600),
    references: [
      Episode.Reference(
        author: "Matt Ricketson and Taylor Kelly",
        blurb: #"""
          A WWDC session covering what's new in SwiftUI this year, including the `refreshable` API.
          """#,
        link: "https://developer.apple.com/videos/play/wwdc2021/10018/",
        publishedAt: yearMonthDayFormatter.date(from: "2021-06-08"),
        title: "What's new in SwiftUI"
      ),
      .pullToRefreshInSwiftUIWithRefreshable,
      Episode.Reference(
        author: nil,
        blurb: #"""
          Documentation for `refreshable`.
          """#,
        link: "https://developer.apple.com/documentation/swiftui/view/refreshable(action:)/",
        publishedAt: nil,
        title: "`refreshable(action:)`"
      ),
    ],
    sequence: 154,
    subtitle: "Composable Architecture",
    title: "Async Refreshable",
    trailerVideo: .init(
      bytesLength: 26_817_157,
      downloadUrls: .s3(
        hd1080: "0154-trailer-1080p-68708441fb5347fb8fc0c1036979dd96",
        hd720: "0154-trailer-720p-d676d15911fb43858823a4c07a056e75",
        sd540: "0154-trailer-540p-a0637329230f4b458426f3eefad052a5"
      ),
      id: "e635c0a947fe23dcf03518dcf2f27ff5"
    )
  )
}

private let _exercises: [Episode.Exercise] = [
  .init(
    problem: #"""
      Use `withTaskCancellationHandler` to allow the async version of `ViewStore.send(_:while:)` to be cancelled. Ensure that the task can be cancelled _before_ the publisher assigns the cancellable.
      """#,
    solution: #"""
      Introducing `withTaskCancellationHandler` and invoking the cancellable's `cancel` method in the handler will allow the handler to cancel the underlying Combine publisher. To handle cancellation that occurs before the operation is invoked, we can call `Task.checkCancellation()` at the beginning of the operation, and again in the continuation. Because continuation closures are not throwing, we must handle cancellation through the continuation's `resume(throwing:)` method instead.

      ```swift
      extension ViewStore {
        func send(
          _ action: Action,
          `while` isInFlight: @escaping (State) -> Bool
        ) async {
          self.send(action)

          var cancellable: Cancellable?
          try? await withTaskCancellationHandler(
            handler: { [cancellable] in cancellable?.cancel() },
            operation: {
              try Task.checkCancellation()
              try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<Void, Error>) in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }
                cancellable = self.publisher
                  .filter { !predicate($0) }
                  .prefix(1)
                  .sink { _ in
                    continuation.resume()
                    _ = cancellable
                  }
              }
            }
          )
        }
      }
      ```
      """#
  ),
  .init(
    problem: #"""
      Introduce a `ViewStore.send(_:animation:while:)` overload with the following signature:

      ```swift
      extension ViewStore {
        func send(
          _ action: Action,
          animation: Animation?,
          while predicate: @escaping (State) -> Bool
        ) async {
          fatalError("unimplemented")
        }
      }
      ```

      Where `animation` animates the synchronous mutation to state caused by `action`.

      Is it possible to implement in terms of `ViewStore.send(_:while:)`? If not, why not, and what are some ways of sharing the original implementation?
      """#,
    solution: #"""
      At this time, it does not appear to be possible to implement this overload in terms of the original, because the mutation happens in the asynchronous context of the upstream `ViewStore.send(_:while:)`, and `withAnimation` can not capture asynchronous work.

      We can instead generalize with another helper that simply suspends a view store till some state holds true:

      ```swift
      extension ViewStore {
        func suspend(while predicate: @escaping (State) -> Bool) async {
          var cancellable: Cancellable?
          try? await withTaskCancellationHandler(
            handler: { [cancellable] in cancellable?.cancel() },
            operation: {
              try Task.checkCancellation()
              try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<Void, Error>) in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }
                cancellable = self.publisher
                  .filter { !predicate($0) }
                  .prefix(1)
                  .sink { _ in
                    continuation.resume()
                    _ = cancellable
                  }
              }
            }
          )
        }
      }
      ```

      And then, both `send` helpers can utilize this shared code:

      ```swift
      extension ViewStore {
        func send(
          _ action: Action,
          while predicate: @escaping (State) -> Bool
        ) async {
          self.send(action)
          await self.suspend(while: predicate)
        }

        func send(
          _ action: Action,
          animation: Animation?,
          while predicate: @escaping (State) -> Bool
        ) async {
          withAnimation(animation) { self.send(action) }
          await self.suspend(while: predicate)
        }
      }
      ```
      """#
  ),
  .init(
    problem: #"""
      The `ViewStore.publisher` property is a handy way of getting a publisher of state to use in Combine. Let's define another property that bridges things to Swift's new concurrency APIs, specifically `AsyncSequence`, by implementing the following:

      ```swift
      extension ViewStore {
        var stream: AsyncStream<State> {
          fatalError("unimplemented")
        }
      }
      ```
      """#,
    solution: #"""
      ```swift
      extension ViewStore {
        var stream: AsyncStream<State> {
          AsyncStream { continuation in
            var cancellable: Cancellable?
            cancellable = self.publisher.sink(
              receiveCompletion: { _ in
                continuation.finish()
                _ = cancellable
              },
              receiveValue: { continuation.yield($0) }
            )
          }
        }
      }
      ```
      """#
  ),
  .init(
    problem: #"""
      Rewrite `ViewStore.suspend(while:)` in terms of the `ViewStore.stream` property, implemented in the previous exercise.
      """#,
    solution: #"""
      ```swift
      extension ViewStore {
        func suspend(while predicate: @escaping (State) -> Bool) async {
          _ = await self.stream
            .filter { !predicate($0) }
            .first(where: { _ in true })
        }
      }
      ```
      """#
  ),
]

extension Episode.Video {
  public static let ep154_asyncRefreshableTCA = Self(
    bytesLength: 364_471_160,
    downloadUrls: .s3(
      hd1080: "0154-1080p-34c9a99975df4e1386a052a651642940",
      hd720: "0154-720p-32f5674cb4214c19a92261cf52896bd3",
      sd540: "0154-540p-293ce43ba7bc4a8685c36223dbd1a7cc"
    ),
    id: "8657beaf5d128032d4d23206796f281e"
  )
}
