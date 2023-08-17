import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileIconImageView: UserIconImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var followeesCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    private var selectedCompletion: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected { selectedCompletion?() }
    }
    
    func configureCell(_ data: UserData, selectedCompletion: (() -> Void)? = nil) {
        nameLabel.text = data.name
        userIdLabel.text = data.id
        followeesCountLabel.text = data.followeesCount?.description
        followersCountLabel.text = data.followersCount?.description
        self.selectedCompletion = selectedCompletion
        
        guard let urlStr = data.profileImageUrl else { return }
        profileIconImageView.loadImageAsynchronously(url: URL(string: urlStr))
    }
}
