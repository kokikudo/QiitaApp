import RxSwift
import RxCocoa
import UIKit

final class UserConnectionsViewModel {
    
    let userData: Driver<[UserData]?>
    
    init(
        input: (
            type: Observable<UserConnectionType>,
            fetchEvent: Observable<Void>
        )) {
            
            let model = UserConnectionsModel()
            
            let pageCount = input.fetchEvent
                .throttle(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
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
        }
}
