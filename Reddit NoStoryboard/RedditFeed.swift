import Foundation

struct RedditFeed {
    let title: String
    let thumbnail_url: String?
    let comments_url: String
    let time: TimeInterval
    let after: String?
}
