import RxSwift
import RxCocoa
import UIKit

class UserSearchViewModel {
    let searchButtonEnabled: Driver<Bool>
    let userData: Driver<UserData?>
    let cacheData: Driver<[UserData]?>
    let isLoading: Driver<Bool>
    
    init(
        input: (
            userId: Driver<String>,
            tapSearchButton: Signal<()>,
            cacheLoad: Observable<()>
        )
    ) {
        
        let model = UserSearchModel()

        searchButtonEnabled = input.userId.map { $0.count > 0 }
        
        let isLoadingRelay = PublishRelay<Bool>()
        isLoading = isLoadingRelay.asDriver(onErrorJustReturn: false)
        
        userData = input.tapSearchButton
            .do(onNext: { _ in
                isLoadingRelay.accept(true)
            })
            .withLatestFrom(input.userId)
            .flatMapLatest { userId in
                return model.fetchPosts(id: userId).asDriver(onErrorJustReturn: nil)
            }
            .do(onNext: { _ in
                isLoadingRelay.accept(false)
            })
        
        cacheData = input.cacheLoad
            .compactMap({ _ in
                return CacheManager.shared.loadUserDataList()
            })
            .asDriver(onErrorJustReturn: nil)
        }
}
