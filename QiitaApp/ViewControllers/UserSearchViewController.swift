import UIKit
import RxSwift
import RxCocoa

class UserSearchViewController: UIViewController {
    @IBOutlet weak var userSearchTextField: UserSearchInputTextField!
    @IBOutlet weak var userSearchButton: UserSearchButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!
    
    private let cacheLoadSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cacheLoadSubject.onNext(())
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SearchHistoryCollectionViewCell", bundle: nil),forCellWithReuseIdentifier:"SearchHistoryCollectionViewCell")
    }
    
    private func setupViewModel() {
        let viewModel = UserSearchViewModel(
            input: (
                userId: userSearchTextField.rx.text.orEmpty.asDriver(),
                tapSearchButton: userSearchButton.rx.tap.asSignal(),
                cacheLoad: cacheLoadSubject.asObserver()
            )
        )
        
        viewModel.searchButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                self?.userSearchButton.isEnabled = isEnabled
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .map { !$0 }
            .drive(loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.userData
            .drive(onNext: { [weak self] data in
                if let safeData = data {
                    self?.showUserDetail(with: safeData)
                    CacheManager.shared.cacheUserDate(safeData)
                } else {
                    self?.showErrorPopup()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.cacheData
            .compactMap { $0 }
            .drive(collectionView.rx.items(cellIdentifier: "SearchHistoryCollectionViewCell")) { index, item, cell in
                if let cell = cell as? SearchHistoryCollectionViewCell {
                    cell.configureCell(item, selectedCompletion: {
                        self.showUserDetail(with: item)
                    })
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func showErrorPopup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ErrorPopupViewController") as? ErrorPopupViewController {
            vc.setData(errorText: "このIDに一致するアカウントは存在しませんでした。")
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func showUserDetail(with data: UserData) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController {
            vc.setData(data)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UserSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 120, height: 120)
       }
}
