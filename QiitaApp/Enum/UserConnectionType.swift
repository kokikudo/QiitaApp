import Foundation

enum UserConnectionType {
    case followees(userId: String)
    case followers(userId: String)
    
    var title: String {
        switch self {
        case .followees(_):
            return "Followees"
        case .followers(_):
            return "Followers"
        }
    }
    
    var apiPath: String {
        switch self {
        case .followees(let userId):
            return "https://qiita.com/api/v2/users/\(userId)/followees"
        case .followers(let userId):
            return "https://qiita.com/api/v2/users/\(userId)/followers"
        }
    }
}
