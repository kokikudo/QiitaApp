import UIKit

class UserSearchButton: UIButton {
    
    @IBInspectable var cournerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cournerRadius
        }
    }
    
}
