import UIKit

class UserSearchButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            setupButton(isEnabled)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 4
        layer.borderWidth = 2
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        setTitleColor(.white, for: .normal)
        setTitleColor(.lightGray, for: .disabled)
    }
    
    private func setupButton(_ isEnable: Bool) {
        layer.borderColor = isEnable ? UIColor.white.cgColor  : UIColor.lightGray.cgColor
    }
}
