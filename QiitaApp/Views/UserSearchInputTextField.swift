import UIKit

class UserSearchInputTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        placeholder = "Input User ID"
        font = UIFont.systemFont(ofSize: 15) 
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
    }
}
