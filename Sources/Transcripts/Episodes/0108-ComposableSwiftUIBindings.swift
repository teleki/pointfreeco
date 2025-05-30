import Foundation

extension Episode {
  public static var ep108_composableSwiftUIBindings_pt2: Self {
    Self(
      blurb: """
        Now that we know that SwiftUI state management seems biased towards structs, let's fix it. We'll show how to write custom transformations on bindings so that we can use enums to model our domains precisely without muddying our views, and it turns out that case paths are the perfect tool for this job.
        """,
      codeSampleDirectory: "0108-composable-bindings-pt2",
      exercises: _exercises,
      id: 108,
      length: 45 * 60 + 40,
      permission: .subscriberOnly,
      publishedAt: Date(timeIntervalSince1970: 1_594_616_400),
      references: [
        .swiftCasePaths,
        .init(
          author: "Brandon Williams & Stephen Celis",
          blurb: #"""
            To learn more about how enums and structs are related to each other, and to understand why we were led to define the concept of "case paths", check out this collection of episodes:

            > Enums are one of Swift's most notable, powerful features, and as Swift developers we love them and are lucky to have them! By contrasting them with their more familiar counterpart, structs, we can learn interesting things about them, unlocking ergonomics and functionality that the Swift language could learn from.
            """#,
          link: "https://www.pointfree.co/collections/enums-and-structs",
          title: "Collection: Enums and Structs"
        ),
        reference(
          forEpisode: .ep13_theManyFacesOfMap,
          additionalBlurb: #"""
            To get a better understanding of the `map` function and how it relates to dynamic member lookup on the Binding type, catch this early episode.
            """#,
          episodeUrl: "https://www.pointfree.co/episodes/ep13-the-many-faces-of-map"
        ),
      ],
      sequence: 108,
      subtitle: "Case Paths",
      title: "Composable SwiftUI Bindings",
      trailerVideo: .init(
        bytesLength: 56_107_510,
        downloadUrls: .s3(
          hd1080: "0108-trailer-1080p-12b070787974481d869e4f5f7cac329c",
          hd720: "0108-trailer-720p-2acf3c0d82a646848ef2a4770f22f8a5",
          sd540: "0108-trailer-540p-42057ddf71f142d0a17542a58de8d06b"
        ),
        id: "80b9e28342b2fab29355b4607ebe85dc"
      )
    )
  }
}

private let _exercises: [Episode.Exercise] = [
  // TODO
]
