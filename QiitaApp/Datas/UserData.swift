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
        guard let id = data["id"] as? String else { return nil }
        
        self.id = id
        self.profileImageUrl = data["profile_image_url"] as? String
        self.followeesCount = data["followees_count"] as? Int
        self.followersCount = data["followers_count"] as? Int
        
        if let description = data["description"] as? String {
            self.description = description.isEmpty ? "no description" : description
        } else {
            self.description = "no description"
        }
        
        if let name = data["name"] as? String {
            self.name = name.isEmpty ? "no name" : name
        } else {
            self.name = "no name"
        }
    }
}
