import Foundation

struct ArticleTagData: Codable {
    let name: String?
}

extension ArticleTagData {
    init?(with tagName: String) {
        self.name = tagName
    }
}
