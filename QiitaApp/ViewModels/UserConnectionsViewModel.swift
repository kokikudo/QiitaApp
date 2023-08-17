import RxSwift
import RxCocoa
import UIKit

final class UserConnectionsViewModel {
    
    let userData: Driver<[UserData]?>
    let isLoading: Driver<Bool>

    init(
        input: (
            type: Observable<UserConnectionType>,
            fetchEvent: Observable<Void>
        )) {
            
            let model = UserConnectionsModel()
            
            let isLoadingRelay = PublishRelay<Bool>()
            isLoading = isLoadingRelay.asDriver(onErrorJustReturn: false)
            
            let pageCount = input.fetchEvent
                .throttle(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
                .do(onNext: { _ in
                    isLoadingRelay.accept(true)
                })
                .scan(into: 0, accumulator: { (sum, _) in
                    sum += 1
                })
            
            let newUserData = Observable
                .combineLatest(input.type, pageCount)
                .flatMapLatest({ (type, pageCount) in
                    return model.fetchPosts(type: type, pageCount: pageCount)
                })
                .compactMap { $0 }
            
            userData = newUserData
                .scan(into: [UserData](), accumulator: { (sum, data) in
                    sum?.append(contentsOf: data)
                })
                .asDriver(onErrorJustReturn: nil)
                .do(onNext: { _ in
                    isLoadingRelay.accept(false)
                })
        }
}
