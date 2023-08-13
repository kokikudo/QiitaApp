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
    let tags: [ArticleTagData]?
    let url: String?
    let createdAt: String?
    let likeCount: Int?
}

extension ArticleData {
    init?(with data: [String: Any]) {

        self.title = data["title"] as? String
        self.url = data["url"] as? String
        self.createdAt = data["created_at"] as? String
        self.likeCount = data["likes_count"] as? Int
        var tagDataList = [ArticleTagData]()
        if let tags = data["tags"] as? [[String: Any]] {
            for tag in tags {
                if let tagName = tag["name"] as? String {
                    tagDataList.append(ArticleTagData(name: tagName))
                }
            }
        }
        self.tags = tagDataList
    }
}
