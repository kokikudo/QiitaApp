import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SafariServices

class UserDetailViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var userIconImageView: UserIconImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var followeesStackView: UIStackView!
    @IBOutlet weak var followeesCountLabel: UILabel!
    @IBOutlet weak var followersStackView: UIStackView!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    
    private var userData: UserData?
    private let disposeBag = DisposeBag()
    private let userIdSubject = PublishSubject<String>()
    private let fetchEventSubject = PublishSubject<Void>()
    private var viewModel: UserDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        addGesturesToStackView()
        setupTitle()
        setupTableView()
        setupViews()
        firstFetch()
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
    
    private func setupViewModel() {
        guard viewModel == nil else { return }
        viewModel = UserDetailViewModel(
            input: (
                id: userIdSubject.asObservable(),
                fetchEvent: fetchEventSubject.asObservable()
            ))
        
        viewModel?.articleDataList
            .compactMap { $0 }
            .drive(tableView.rx.items(cellIdentifier: "ArticleTableViewCell")) { index, item, cell in
                if let cell = cell as? ArticleTableViewCell {
                    cell.configureCell(item, selectedCompletion: {
                        self.showArticleDetail(with: item)
                    })
                }
            }
            .disposed(by: disposeBag)
        
        viewModel?.isLoading
            .map { !$0 }
            .drive(loadingView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func setupTitle() {
        guard let data = userData else { return }
        var title = ""
        if let name = data.name {
            title += name
        }
        if let id = data.id {
            title += "@" + id
        }
        navigationItem.title = title
    }
    
    private func updateData(_ data: UserData) {
        userData = data
        setupViews()
        resetViewModel()
    }
    
    private func resetViewModel() {
        viewModel = nil
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        setupViewModel()
        firstFetch()
    }
    
    private func firstFetch() {
        if let id = userData?.id {
            userIdSubject.onNext(id)
            fetchEventSubject.onNext(())
        }
    }
    
    private func fetchNextPage() {
        fetchEventSubject.onNext(())
    }
    
    private func setupTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.separatorStyle = .none
        tableView.rowHeight = 140
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
            present(vc, animated: true)
        }
    }
    
    private func setupViews() {
        userNameLabel.text = userData?.name
        if let id = userData?.id {
            userIdLabel.text = "@" + id
        }
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.bounds.size.height
        
        if offsetY > contentHeight - scrollViewHeight - 50 {
            fetchNextPage()
        }
    }
}
