import Cloudflare
import Foundation
import Tagged
import TaggedTime

public struct Clip: Codable, Equatable {
  public let id: ID
  public var blurb: String
  public let cloudflareVideoID: Cloudflare.Video.ID
  public let createdAt: Date
  public let description: String
  public let duration: Seconds<Int>
  public let order: Int
  public let posterURL: String
  public let title: String

  public typealias ID = Tagged<Self, UUID>

  public init(
    cloudflareVideoID: Cloudflare.Video.ID
  ) {
    self.id = ID(rawValue: UUID())
    self.blurb = ""
    self.cloudflareVideoID = cloudflareVideoID
    self.createdAt = Date(timeIntervalSince1970: 0)
    self.description = ""
    self.duration = 0
    self.order = 0
    self.posterURL = "image.png"
    self.title = ""
  }

  public init(
    id: ID,
    blurb: String,
    cloudflareVideoID: Cloudflare.Video.ID,
    createdAt: Date,
    description: String,
    duration: Seconds<Int>,
    order: Int,
    posterURL: String,
    title: String
  ) {
    self.id = id
    self.blurb = blurb
    self.cloudflareVideoID = cloudflareVideoID
    self.createdAt = createdAt
    self.description = description
    self.duration = duration
    self.order = order
    self.posterURL = posterURL
    self.title = title
  }

  enum CodingKeys: String, CodingKey {
    case id
    case blurb
    case cloudflareVideoID = "cloudflare_video_id"
    case createdAt = "created_at"
    case description
    case duration
    case order
    case posterURL = "poster_url"
    case title
  }
}
