import Foundation

extension Episode {
  static let ep52_enumProperties = Episode(
    blurb: """
      Swift makes it easy for us to access the data inside a struct via dot-syntax and key-paths, but enums are provided no such affordances. This week we correct that deficiency by defining the concept of "enum properties", which will give us an expressive way to dive deep into the data inside our enums.
      """,
    codeSampleDirectory: "0052-enum-properties",
    exercises: _exercises,
    id: 52,
    length: 24 * 60 + 38,
    permission: .subscriberOnly,
    publishedAt: .init(timeIntervalSince1970: 1_554_098_400),
    references: [
      reference(
        forEpisode: .ep8_gettersAndKeyPaths,
        additionalBlurb: """
          An episode dedicated to property access on structs and how key paths can further aid us in writing expressive code.
          """,
        episodeUrl: "https://www.pointfree.co/episodes/ep8-getters-and-key-paths"
      ),
      .se0249KeyPathExpressionsAsFunctions,
      Episode.Reference(
        author: "Zoë Smith",
        blurb:
          "This site is a cheat sheet for `if case let` syntax in Swift, which can be seriously complicated.",
        link: "http://goshdarnifcaseletsyntax.com",
        publishedAt: nil,
        title: "How Do I Write If Case Let in Swift?"
      ),
    ],
    sequence: 52,
    title: "Enum Properties",
    trailerVideo: .init(
      bytesLength: 38_869_888,
      downloadUrls: .s3(
        hd1080: "0052-trailer-1080p-f723e723482841b0b898d1f6c58e6d0a",
        hd720: "0052-trailer-720p-843b5c5a73444d73b85feb03c3d361d5",
        sd540: "0052-trailer-540p-6db1e489a9044ff99fac263f02e9ae07"
      ),
      id: "3f8b9eec969a09528f3986c23cdf1305"
    )
  )
}

private let _exercises: [Episode.Exercise] = [
  Episode.Exercise(
    problem: """
      While we've defined the `get`s of our enum properties, we haven't defined our `set`s. Redefine `Validated`'s `valid` and `invalid` properties to have a setter in addition to its getter.
      """,
    solution: """
      We can redefine `valid` with the following setter.

      ```
      var valid: Valid? {
        get {
          guard
            case let .valid(value) = self
            else { return nil }
          return value
        }
        set {
          guard
            let newValue = newValue,
            case .valid = self
            else { return }
          self = .valid(newValue)
        }
      }
      ```

      While we must safely unwrap a non-optional `newValue` to reassign `self`, we also test that the current `self` is `valid` before doing so.

      The `invalid` property is the same boilerplate but uses the `invalid` case.

      ```
      var invalid: [Invalid]? {
        get {
          guard
            case let .invalid(value) = self
            else { return nil }
          return value
        }
        set {
          guard
            let newValue = newValue,
            case .invalid = self
            else { return }
          self = .invalid(newValue)
        }
      }
      ```
      """
  ),
  Episode.Exercise(
    problem: """
      Take the `valid` setter for a spin. Assign `Validated<Int, String>.valid(1)` to a variable and increment the number using the setter.
      """,
    solution: """
      There are a few ways of doing this! First, let's assign a mutable variable.

      ```
      var v = Validated<Int, String>.valid(1)
      ```

      We can `map` over the optional `Int` returned by the `valid` getter.

      ```
      v.valid = v.valid.map { $0 + 1 }
      ```

      Or we can optionally chain with the `+=` operator.

      ```
      v.valid? += 1
      """
  ),
]
