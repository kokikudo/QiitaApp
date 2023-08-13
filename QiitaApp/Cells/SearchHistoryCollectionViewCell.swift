import UIKit

class SearchHistoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileIconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    private var selectedCompletion: (() -> Void)?

    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectedCompletion?()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(_ data: UserData, selectedCompletion: (() -> Void)? = nil) {
        nameLabel.text = data.name
        userIdLabel.text = data.id
        self.selectedCompletion = selectedCompletion
        
        guard let urlStr = data.profileImageUrl else { return }
        profileIconImageView.loadImageAsynchronously(url: URL(string: urlStr))
    }
}
