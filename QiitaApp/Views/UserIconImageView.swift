import UIKit

class UserIconImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = frame.height / 2
    }
    
}
