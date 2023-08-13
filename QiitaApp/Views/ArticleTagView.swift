import UIKit

class ArticleTagView: UIView {
    
    @IBOutlet private var nameLabel: UILabel!
        
    var nameLabelText: String? {
        get { return nameLabel.text }
        set { nameLabel.text = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = AppTheme.articleTagBgColor
        layer.cornerRadius = 4.0
    }
}
