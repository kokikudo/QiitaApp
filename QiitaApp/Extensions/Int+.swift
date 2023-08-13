import Foundation

extension Int? {
    var strongValue: Int {
        if let value = self {
            return value
        } else {
            return 0
        }
    }
}
