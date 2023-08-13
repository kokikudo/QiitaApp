import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SafariServices

class UserDetailViewController: UIViewController {

    @IBOutlet weak var userIconImageView: UserIconImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var followeesStackView: UIStackView!
    @IBOutlet weak var followeesCountLabel: UILabel!
    @IBOutlet weak var followersStackView: UIStackView!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var userData: UserData?
    private let disposeBag = DisposeBag()
    private var model = UserDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.title = "詳細画面"
        setupTableView()
        setupViews()
        model.fetchArticles(userId: userData?.id)
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func setData(_ data: UserData) {
        userData = data
    }
    
    private func updateData(_ data: UserData) {
        userData = data
        setupViews()
        model.fetchArticles(userId: userData?.id)
    }
    
    private func bind() {
        model.articlesReloadEvent.subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        })
        .disposed(by: disposeBag)
        
        addGesturesToStackView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil),forCellReuseIdentifier:"ArticleTableViewCell")

    }
    
    private func addGesturesToStackView() {
        let tapGesture = UITapGestureRecognizer()
        followeesStackView.addGestureRecognizer(tapGesture)
        followeesStackView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard
                    let userId = self?.userData?.id,
                    let count = self?.userData?.followeesCount
                else { return }
                
                if count > 0 {
                    let type = UserConnectionType.followees(userId: userId)
                    self?.showUserConnections(type: type)
                }
                
            })
            .disposed(by: disposeBag)
        
        followersStackView.addGestureRecognizer(tapGesture)
        followersStackView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard
                    let userId = self?.userData?.id,
                    let count = self?.userData?.followersCount
                else { return }
                
                if count > 0 {
                    let type = UserConnectionType.followers(userId: userId)
                    self?.showUserConnections(type: type)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showUserConnections(type: UserConnectionType) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "UserConnectionsViewController") as? UserConnectionsViewController {
            vc.setData(type, dismissCompletion: ({ userData in
                self.updateData(userData)
            }))
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func setupViews() {
        userNameLabel.text = userData?.name
        descriptionTextView.text = userData?.description
        followeesCountLabel.text = userData?.followeesCount?.description
        followersCountLabel.text = userData?.followersCount?.description
        
        guard let urlStr = userData?.profileImageUrl else { return }
        userIconImageView.loadImageAsynchronously(url: URL(string: urlStr))
    }
    
    private func showArticleDetail(with data: ArticleData) {
        guard
            let urlStr = data.url,
            let url = URL(string: urlStr)
        else { return }
        
        let vc = SFSafariViewController(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = model.getArticles()[indexPath.row]
        showArticleDetail(with: article)
    }
}

extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getArticles().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
                
        cell.configureCell(model.getArticles()[indexPath.row])
        return cell
    }
}
