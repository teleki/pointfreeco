import Foundation

extension Episode {
  public static let ep118_redactions_pt4 = Episode(
    alternateSlug: "redacted-swiftui-the-point-part-2",
    blurb: """
      We finish building a rich onboarding experience for our application by selectively enabling and disabling pieces of logic in the app depending on what step of the onboarding process we are on. This is only possible due to the strict "separation of concerns" the Composable Architecture maintains.
      """,
    codeSampleDirectory: "0118-redacted-swiftui-pt4",
    exercises: _exercises,
    id: 118,
    length: 26 * 60 + 21,
    permission: .subscriberOnly,
    publishedAt: Date(timeIntervalSince1970: 1_600_664_400),
    references: [
      .init(
        author: nil,
        blurb: #"""
          Apple's new API for redacting content in SwiftUI.
          """#,
        link: "https://developer.apple.com/documentation/swiftui/view/redacted(reason:)",
        publishedAt: nil,
        title: "redacted(reason:)"
      ),
      .init(
        author: nil,
        blurb: #"""
          "Separation of Concerns" is a design pattern that is expressed often but is a very broad guideline, and not something that can be rigorously applied.
          """#,
        link: "https://en.wikipedia.org/wiki/Separation_of_concerns",
        publishedAt: nil,
        title: "Separation of Concerns"
      ),
    ],
    sequence: 118,
    title: "The Point of Redacted SwiftUI: Part 2",
    trailerVideo: .init(
      bytesLength: 28_968_407,
      downloadUrls: .s3(
        hd1080: "0118-trailer-1080p-0d05ae64e6d04986a11f01bcc872e044",
        hd720: "0118-trailer-720p-161f2a8fc8c1425395c6344b7f22b36f",
        sd540: "0118-trailer-540p-ee64f23601914fb0904849f9726fb5c5"
      ),
      id: "f7f617a7df0fa36688fbbd0ea628c240"
    )
  )
}

private let _exercises: [Episode.Exercise] = [
  Episode.Exercise(
    problem: #"""
      Add `isSkipButtonHidden` state to `OnboardingState` and have it hide the skip button when on the last step of the onboarding flow
      """#
  ),
  Episode.Exercise(
    problem: #"""
      Update the onboarding reducer to allow new todos to be added when on the `actions` step.
      """#
  ),
  Episode.Exercise(
    problem: #"""
      Generalize the onboarding analytics client by defining a method that can "tag" an analytics client with a given string:

      ```swift
      extension AnalyticsClient {
        func tagged(_ tag: String) -> Self {
          fatalError("unimplemented")
        }
      }
      ```
      """#
  ),
  Episode.Exercise(
    problem: #"""
      Update the onboarding flow to automatically transition from step 1 to step 2 after adding a todo.
      """#
  ),
  Episode.Exercise(
    problem: #"""
      Update the onboarding flow to automatically transition from step 2 to step 3 after changing the filter a couple times.
      """#
  ),
  Episode.Exercise(
    problem: #"""
      Update the onboarding flow to automatically transition from step 3 to done after marking a few todos complete.
      """#
  ),
  Episode.Exercise(
    problem: #"""
      Write some tests!
      """#
  ),
]
