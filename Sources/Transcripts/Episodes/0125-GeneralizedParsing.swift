import Foundation

extension Episode {
  public static let ep125_generalizedParsing = Episode(
    blurb: """
      Now that we have generalized the parser type it's time to parse things that aren't just plain strings. In just a few lines of code the parser type can parse environment variable dictionaries and even become a fully capable URL router.
      """,
    codeSampleDirectory: "0125-generalized-parsing-pt2",
    exercises: _exercises,
    id: 125,
    length: 53 * 60 + 52,
    permission: .subscriberOnly,
    publishedAt: Date(timeIntervalSince1970: 1_605_506_400),
    references: [
      // https://github.com/inamiy/FunRouter ?
    ],
    sequence: 125,
    subtitle: "Part 2",
    title: "Generalized Parsing",
    trailerVideo: .init(
      bytesLength: 019_143_341,
      downloadUrls: .s3(
        hd1080: "0125-trailer-1080p-84c9c05047dd4e26b53319b89f9ef499",
        hd720: "0125-trailer-720p-d4d9e4b8368f49f6ac0b044eb3dfce09",
        sd540: "0125-trailer-540p-a5ef502425ef48c086d2d4b023617f79"
      ),
      id: "301a2b43248c832a95b37db5bb1a122e"
    )
  )
}

private let _exercises: [Episode.Exercise] = [
  Episode.Exercise(
    problem: #"""
      Write a function that transforms a `URLRequest` into the parser-friendly `RequestData` type.
      """#,
    solution: #"""
      ```swift
      extension RequestData {
        init(urlRequest: URLRequest) {
          self.body = urlRequest.httpBody
          self.headers = urlRequest.allHTTPHeaderFields?.mapValues { $0[...] } ?? [:]
          self.method = urlRequest.httpMethod
          self.pathComponents = urlRequest.url?.path.split(separator: "/")[...] ?? []
          self.queryItems = urlRequest.url
            .flatMap {
              URLComponents(url: $0, resolvingAgainstBaseURL: false)?.queryItems?
                .map { ($0.name, $0.value?[...] ?? "") }
            }
            ?? []
        }
      }
      ```
      """#
  ),
  Episode.Exercise(
    problem: #"""
      Implement a header parser that can parse a value from a given header name. For example:

      ```swift
      Parser.header(name: "Content-Length", .int)
      // Parser<RequestData, Int>
      ```
      """#,
    solution: #"""
      ```swift
      extension Parser where Input == RequestData {
        static func header(name: String, _ parser: Parser<Substring, Output>) -> Self {
          .init { input in
            guard
              var value = input.headers[name],
              let output = parser.run(&value),
              value.isEmpty
            else { return nil }

            input.headers[name] = nil
            return output
          }
        }
      }
      ```
      """#
  ),
  Episode.Exercise(
    problem: #"""
      Implement a JSON body parser that can decode a particular value from a request body. For example:

      ```swift
      struct User: Decodable {
        var id: Int
        var name: String
      }

      Parser.body(as: User.self, decoder: JSONDecoder())
      // Parser<RequestData, User>
      ```
      """#,
    solution: #"""
      ```swift
      extension Parser where Input == RequestData {
        static func body(
          as decodable: Output.Type = Output.self,
          decoder: JSONDecoder = .init()
        ) -> Self where Output: Decodable {
          .init { input in
            guard
              let data = input.body,
              let output = try? decoder.decode(decodable, from: data)
            else { return nil }

            input.body = nil
            return output
          }
        }
      }
      ```
      """#
  ),
]
