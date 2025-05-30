import Foundation

extension Episode {
  public static let ep322_sqlBuilding = Episode(
    blurb: """
      We close out our series on SQL query building with a library that can generate some \
      seriously complex queries that select, join, group, aggregate, and filter data across \
      tables. And we show how it can all play nicely with SQL strings by introducing a safe \
      interface to SQL _via_ a custom string interpolation.
      """,
    codeSampleDirectory: "0322-sql-building-pt9",
    exercises: _exercises,
    id: 322,
    length: 33 * 60 + 04,
    permission: .subscriberOnly,
    publishedAt: yearMonthDayFormatter.date(from: "2025-04-21")!,
    references: [
      .init(
        blurb: "The SQLite home page",
        link: "https://www.sqlite.org",
        title: "SQLite"
      )
    ],
    sequence: 322,
    subtitle: "Advanced Joins",
    title: "SQL Builders",
    trailerVideo: .init(
      bytesLength: 40_400_000,
      downloadUrls: .s3(
        hd1080: "0322-trailer-1080p-0b787753ad5545a1a7677f21891d55c9",
        hd720: "0322-trailer-720p-a224932f2c264f7d85c1b280efb5e25a",
        sd540: "0322-trailer-540p-70236aded18a471da8db8d1b356e197a"
      ),
      id: "87a009364a891f0238ce6378a213e2cc"
    )
  )
}

private let _exercises: [Episode.Exercise] = [
  // TODO
]
