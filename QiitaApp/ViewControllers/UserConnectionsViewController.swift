import UIKit
import RxSwift
import RxCocoa

class UserConnectionsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    
    private var userConnectionType: UserConnectionType?
    private let disposeBag = DisposeBag()
    private let typeSubject = PublishSubject<UserConnectionType>()
    private let fetchEventSubject = PublishSubject<Void>()
    private var dismissCompletion: ((UserData) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupViewModel()
        firstFetch()
        titleLabel.text = userConnectionType?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func setData(_ type: UserConnectionType, dismissCompletion: ((UserData) -> Void)? = nil) {
        userConnectionType = type
        self.dismissCompletion = dismissCompletion
    }
    
    private func setupViewModel() {
        let viewModel = UserConnectionsViewModel(
            input: (
                type: typeSubject.asObservable(),
                fetchEvent: fetchEventSubject.asObservable()
            ))
        
        viewModel.userData
            .compactMap { $0 }
            .drive(tableView.rx.items(cellIdentifier: "UserTableViewCell")) { index, item, cell in
                if let cell = cell as? UserTableViewCell {
                    cell.configureCell(item, selectedCompletion: {
                        self.updateUserDetail(with: item)
                    })
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .map { !$0 }
            .drive(loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func firstFetch() {
        if let type = userConnectionType {
            typeSubject.onNext(type)
            fetchEventSubject.onNext(())
        }
    }
    
    private func fetchNextPage() {
        fetchEventSubject.onNext(())
    }
    
    private func setupTableView() {
        tableView.rowHeight = 75
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil),forCellReuseIdentifier:"UserTableViewCell")
    }
    
    private func updateUserDetail(with data: UserData) {
        dismiss(animated: true) {
            self.dismissCompletion?(data)
        }
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
