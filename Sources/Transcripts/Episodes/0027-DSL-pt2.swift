import Foundation

extension Episode {
  static let ep27_domainSpecificLanguages_pt2 = Episode(
    blurb: """
      We finish our introduction to DSLs by adding two new features to our toy example: support for multiple variables and support for let-bindings so that we can share subexpressions within a larger expression. With these fundamentals out of the way, we will be ready to tackle a real-world DSL soon!
      """,
    codeSampleDirectory: "0027-edsls-pt2",
    exercises: _exercises,
    id: 27,
    length: 20 * 60 + 17,
    permission: .subscriberOnly,
    publishedAt: Date(timeIntervalSince1970: 1_535_349_423),
    sequence: 27,
    title: "Domain‑Specific Languages: Part 2",
    trailerVideo: .init(
      bytesLength: 74_226_609,
      downloadUrls: .s3(
        hd1080: "0027-trailer-1080p-6da1af1ad29044cfacbd6a22f2e9ed81",
        hd720: "0027-trailer-720p-8acd6a8e5a2a488d8beab2a6ef992f18",
        sd540: "0027-trailer-540p-ef2d1d81a0a04877801eb9dc8b384729"
      ),
      id: "1a7448904e65b679c9c5c8f0fe938353"
    )
  )
}

private let _exercises: [Episode.Exercise] = [
  .init(
    problem: """
      Implement an inliner function `inline: (Expr) -> Expr` that removes all `let`-bindings and inlines the body
      of the binding directly into the subexpression.
      """),

  .init(
    problem: """
      Implement a function `freeVars: (Expr) -> String` that collects all of the variables used in an expression.
      """),

  .init(
    problem: """
      Define an infix operator `.=` to mimic `let`-bindings. At the call site its usage might look something like:
      `("x" .= 3)("x" * 2 + 3)`, where we are using the infix operators `*` and `+` defined in the exercises
      of the [last episode](/episodes/ep26-domain-specific-languages-part-1).
      """),

  .init(
    problem: """
      Update `bind` to take a dictionary of bindings rather than a single binding.
      """),

  .init(
    problem: """
      In this exercise we are going to implement a function `D: (String) -> (Expr) -> Expr` that computes the
      derivative of any expression you give it. This may sound scary, but we'll take it one step at a time!

      * Let's start simple. The signature `D: (String) -> (Expr) -> Expr` represents the concept of taking the
      derivative of an expression _with respect to_ some variable, specified by the `String` argument. Write down
      the signature of this function, and call the string argument `variable`. This string is the variable with
      respect to which you will be differentiating. Also implement the body as a closure that takes a single
      argument (the expression), and inside the closure implement the `switch` over that argument while leaving all
      the cases unimplemented.

      * Derivatives have the simple property that they _annihilate_ constants: `D(1) = 0`, `D(-1) = 0`, `D(2) = 0`,
      i.e. the derivate of any constant is zero. Use this fact to implement the `.lit` case in the `switch` you
      defined above.

      * Derivatives also have a simple property for variables. The derivative of a variable with respect to that
      variable is simply `1`, and the derivative of any variable with respect to any _other_ variable is `0`. Use
      this fact to implement the `.var` case in the `switch` you defined above.

      * Derivatives have the wonderful property that they _distribute_ over addition: `D(f + g) = D(f) + D(g)`,
      i.e. the derivative of a sum is the sum of the derivatives. Use this fact to implement the `.add` case
      in the `switch` you defined above.

      * Derivatives have a slightly more complicated relationship with multplication. It is _not_ true that
      derivatives distribute over multiplication, but they do something close: `D(f * g) = D(f) * g + f * D(g)`.
      Use this fact to implement the `.mul` case in the `switch` you defined above.

      * Finally, derivatives have an even more complicated relationship with let-bindings:
      `D(f >>> g) = D(f) * (f >>> D(g))`, where here we are using `>>>` as a shorthand to represent the idea that
      let-bindings are essentially function composition. It's a lot to take in, but what this is saying is that
      you take the derivative of the expression you are binding `D(f)`, multiply that with the derivative of the
      subexpression that uses the binding `D(g)` pre-composed with the binding `f >>> D(g)`. Use this fact to
      implement the `.bind` case in the `switch` you defined above.

      If you can solve these exercises, you've essentially done a semester's worth of calculus!
      """),

  .init(
    problem: """
      Use the `D` function defined above to differentiate some expressions.
      """),
]
