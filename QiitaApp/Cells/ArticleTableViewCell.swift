import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var tagsStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(_ data: ArticleData) {
        createDateLabel.text = DateManager.convertDateString(dateString: data.createdAt.storongValue)
        titleLabel.text = data.title
        likesCount.text = data.likeCount.strongValue.description
        
        guard let tags = data.tags else { return }
        removeAllStackSubviews()
        for tag in tags {
            guard let tagName = tag.name else { continue }
            let tagView = createTagView(name: tagName)
            tagsStackView.addArrangedSubview(tagView)
        }
        addEmptyViewInStackView()
    }
    
    private func createTagView(name: String) -> ArticleTagView {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        let view = Bundle.main.loadNibNamed("ArticleTagView", owner: nil, options: nil)?.first as! ArticleTagView
        view.frame = frame
        view.nameLabelText = name
        return view
    }
    
    private func removeAllStackSubviews() {
        for view in tagsStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    private func addEmptyViewInStackView() {
        tagsStackView.addArrangedSubview(UIView())
    }
}
