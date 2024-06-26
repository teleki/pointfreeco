import Dependencies
import Html
import HtmlPlainTextPrint
import HttpPipeline
import PointFreeTestSupport
import Prelude
import SnapshotTesting
import XCTest

@testable import PointFree

#if !os(Linux)
  import WebKit
#endif

class NewEpisodeEmailTests: TestCase {
  @Dependency(\.episodes) var episodes

  override func setUp() async throws {
    try await super.setUp()
    //SnapshotTesting.isRecording=true
  }

  @MainActor
  func testNewEpisodeEmail_Subscriber() async throws {
    let doc = newEpisodeEmail((self.episodes().first!, "", "", .mock))

    await assertSnapshot(matching: doc, as: .html)
    await assertSnapshot(matching: plainText(for: doc), as: .lines)

    #if !os(Linux)
      if self.isScreenshotTestingAvailable {
        let webView = WKWebView(frame: .init(x: 0, y: 0, width: 900, height: 1200))
        webView.loadHTMLString(render(doc), baseURL: nil)
        await assertSnapshot(matching: webView, as: .image)

        webView.frame.size = .init(width: 400, height: 1100)
        await assertSnapshot(matching: webView, as: .image)
      }
    #endif
  }

  @MainActor
  func testNewEpisodeEmail_FreeEpisode_NonSubscriber() async throws {
    var episode = self.episodes().first!
    episode.permission = .free

    let doc = newEpisodeEmail((episode, "", "", .nonSubscriber))

    await assertSnapshot(matching: doc, as: .html)
    await assertSnapshot(matching: plainText(for: doc), as: .lines)

    #if !os(Linux)
      if self.isScreenshotTestingAvailable {
        let webView = WKWebView(frame: .init(x: 0, y: 0, width: 900, height: 1200))
        webView.loadHTMLString(render(doc), baseURL: nil)
        await assertSnapshot(matching: webView, as: .image)

        webView.frame.size = .init(width: 400, height: 1100)
        await assertSnapshot(matching: webView, as: .image)
      }
    #endif
  }

  @MainActor
  func testNewEpisodeEmail_Announcement_NonSubscriber() async throws {
    let episode = self.episodes().first!

    let doc = newEpisodeEmail(
      (
        episode,
        "This is an announcement for subscribers.",
        "This is an announcement for NON-subscribers.",
        .nonSubscriber
      ))

    await assertSnapshot(matching: doc, as: .html)
    await assertSnapshot(matching: plainText(for: doc), as: .lines)

    #if !os(Linux)
      if self.isScreenshotTestingAvailable {
        let webView = WKWebView(frame: .init(x: 0, y: 0, width: 900, height: 1200))
        webView.loadHTMLString(render(doc), baseURL: nil)
        await assertSnapshot(matching: webView, as: .image)

        webView.frame.size = .init(width: 400, height: 1100)
        await assertSnapshot(matching: webView, as: .image)
      }
    #endif
  }

  @MainActor
  func testNewEpisodeEmail_Announcement_Subscriber() async throws {
    let episode = self.episodes().first!

    let doc = newEpisodeEmail(
      (
        episode,
        "This is an announcement for subscribers.",
        "This is an announcement for NON-subscribers.",
        .mock
      ))

    await assertSnapshot(matching: doc, as: .html)
    await assertSnapshot(matching: plainText(for: doc), as: .lines)

    #if !os(Linux)
      if self.isScreenshotTestingAvailable {
        let webView = WKWebView(frame: .init(x: 0, y: 0, width: 900, height: 1200))
        webView.loadHTMLString(render(doc), baseURL: nil)
        await assertSnapshot(matching: webView, as: .image)

        webView.frame.size = .init(width: 400, height: 1100)
        await assertSnapshot(matching: webView, as: .image)
      }
    #endif
  }

  @MainActor
  func testNewEpisodeEmail_Markdown() async throws {
    var episode = self.episodes().first!
    episode.blurb = """
      Crafting better test dependencies for our code bases come with additional benefits outside of testing. We show how SwiftUI previews can be strengthened from better dependencies, and we show how we employ these techniques in our newly released game, [isowords](https://www.isowords.xyz).
      """

    let doc = newEpisodeEmail(
      (
        episode,
        "This is an announcement for subscribers.",
        "This is an announcement for NON-subscribers.",
        .mock
      ))

    await assertSnapshot(matching: doc, as: .html)
    await assertSnapshot(matching: plainText(for: doc), as: .lines)

    #if !os(Linux)
      if self.isScreenshotTestingAvailable {
        let webView = WKWebView(frame: .init(x: 0, y: 0, width: 900, height: 1200))
        webView.loadHTMLString(render(doc), baseURL: nil)
        await assertSnapshot(matching: webView, as: .image)

        webView.frame.size = .init(width: 400, height: 1100)
        await assertSnapshot(matching: webView, as: .image)
      }
    #endif
  }
}
