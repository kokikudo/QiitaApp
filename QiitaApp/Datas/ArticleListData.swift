import Foundation

struct ArticleListData: Codable {
    let list: [ArticleData?]
}

extension ArticleListData {
    init?(with data: [[String: Any]]) {
        self.list = data.map({ d in
            return ArticleData(with: d)
        })
    }
}

struct ArticleData: Codable {
    let title: String?
    let tags: String?
    let url: String?
    let createdAt: String?
    let likeCount: Int?
}

extension ArticleData {
    init?(with data: [String: Any]) {

        self.title = data["title"] as? String
        self.tags = data["tags"] as? String
        self.url = data["url"] as? String
        self.createdAt = data["createdAt"] as? String
        self.likeCount = data["likeCount"] as? Int
    }
}
