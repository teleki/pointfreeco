import Foundation

extension Episode {
  public static let ep180_parserPrinters = Episode(
    blurb: """
      We will chip away at more and more parser printer conformances, some of which will truly stretch our brains, but we will finally turn our complex user CSV parser into a printer!
      """,
    codeSampleDirectory: "0180-parser-printers-pt3",
    exercises: _exercises,
    id: 180,
    length: 40 * 60 + 46,
    permission: .subscriberOnly,
    publishedAt: Date(timeIntervalSince1970: 1_646_632_800),
    references: [
      .invertibleSyntaxDescriptions,
      .unifiedParsingAndPrintingWithPrisms,
    ],
    sequence: 180,
    subtitle: "The Solution, Part 2",
    title: "Invertible Parsing",
    trailerVideo: .init(
      bytesLength: 8_457_721,
      downloadUrls: .s3(
        hd1080: "0180-trailer-1080p-477fdcdf2d13495b845b5a43829550ef",
        hd720: "0180-trailer-720p-7705e40147f14093adf6d01496fd35dc",
        sd540: "0180-trailer-540p-d215d31a32954cd1ab11d027264739a8"
      ),
      id: "2b312c26c0711f2dd1dba2b29ab79662"
    )
  )
}

private let _exercises: [Episode.Exercise] = [
  // TODO
]
