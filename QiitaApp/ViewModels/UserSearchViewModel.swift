import RxSwift
import RxCocoa
import UIKit

class UserSearchViewModel {
    let searchButtonEnabled: Driver<Bool>
    let userData: Driver<UserData?>
    let cacheData: Driver<[UserData]?>
    
    init(
        input: (
            userId: Driver<String>,
            tapSearchButton: Signal<()>,
            cacheLoad: Observable<()>
        )
    ) {
        
        let model = UserSearchModel()

        searchButtonEnabled = input.userId.map { $0.count > 0 }
        
        userData = input.tapSearchButton
            .withLatestFrom(input.userId)
            .flatMapLatest { userId in
                return model.fetchPosts(id: userId).asDriver(onErrorJustReturn: nil)
            }
        
        cacheData = input.cacheLoad
            .compactMap({ _ in
                return CacheManager.shared.loadUserDataList()
            })
            .asDriver(onErrorJustReturn: nil)
        }
}
