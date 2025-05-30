import Foundation

extension Episode {
  static let ep40_asyncFunctionalRefactoring = Episode(
    blurb: """
      The snapshot testing library we have been designing over the past few weeks has a serious problem: it can't snapshot asynchronous values, like web views and anything that uses delegates or callbacks. Today we embark on a no-regret refactor to fix this problem with the help of a well-studied and well-understood functional type that we have discussed numerous times before.
      """,
    codeSampleDirectory: "0040-async-functional-refactoring",
    exercises: _exercises,
    id: 40,
    length: 34 * 60 + 8,
    permission: .subscriberOnly,
    publishedAt: .init(timeIntervalSince1970: 1_545_030_000),
    references: [
      .protocolOrientedProgrammingWwdc,
      .iosSnapshotTestCaseGithub,
      .snapshotTestingBlogPost,
    ],
    sequence: 40,
    title: "Async Functional Refactoring",
    trailerVideo: .init(
      bytesLength: 71_878_337,
      downloadUrls: .s3(
        hd1080: "0040-trailer-1080p-226f6ba7d2834dff89cff2e7344f99f1",
        hd720: "0040-trailer-720p-28348870e4824f9c8c71aabbf8d41f62",
        sd540: "0040-trailer-540p-cdada1876a084721b48692e8c53f0c5f"
      ),
      id: "951d1d99ee7971a4d7e51023d4596f1d"
    )
  )
}

private let _exercises: [Episode.Exercise] = [
  .init(
    problem: """
      Redefine `pullback` on `Snapshotting` in terms of `asyncPullback`.
      """),
  .init(
    problem: """
      While we were introduced to `pullback` by doing a deep dive on contravariance, `asyncPullback` seems to have a different shape.

      Extract the `snapshot` logic of `asyncPullback` to a more general function on `Parallel`. What is the shape of this function? Is it familiar? What other types from past episodes have a similar operation?
      """),
]
