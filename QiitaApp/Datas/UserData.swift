import Foundation

struct UserData: Codable {
    let profileImageUrl: String?
    let name: String?
    let id: String?
    let description: String?
    let followeesCount: Int?
    let followersCount: Int?
}

extension UserData {
    init?(with data: [String: Any]) {

        self.profileImageUrl = data["profile_image_url"] as? String
        self.name = data["name"] as? String
        self.id = data["id"] as? String
        self.description = data["description"] as? String
        self.followeesCount = data["followees_count"] as? Int
        self.followersCount = data["followers_count"] as? Int
    }
}
