import UIKit

extension String? {
    var storongValue: String {
        if let value = self {
            return value
        } else {
            return ""
        }
    }
}
