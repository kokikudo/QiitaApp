import UIKit
import RxSwift
import RxCocoa

class UserConnectionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var userConnectionType: UserConnectionType?
    private let disposeBag = DisposeBag()
    private let typeSubject = PublishSubject<UserConnectionType>()
    private var dismissCompletion: ((UserData) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupViewModel()
        fetchType()
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
            type: typeSubject.asDriver(onErrorJustReturn: .followees(userId: ""))
            )
        
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
    }
    
    private func fetchType() {
        if let type = userConnectionType {
            typeSubject.onNext(type)
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil),forCellReuseIdentifier:"UserTableViewCell")
    }
    
    private func updateUserDetail(with data: UserData) {
        dismiss(animated: true) {
            self.dismissCompletion?(data)
        }
    }
}
