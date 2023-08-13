import UIKit

class InspectableUIView: UIView {
    
    @IBInspectable var cournerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cournerRadius
        }
    }
    
}
