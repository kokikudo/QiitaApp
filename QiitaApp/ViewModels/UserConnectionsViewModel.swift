import RxSwift
import RxCocoa
import UIKit

final class UserConnectionsViewModel {
    
    let userData: Driver<[UserData]?>
    
    init(type: Driver<UserConnectionType>) {
        
        let model = UserConnectionsModel()
        
        userData = type
            .flatMapLatest { type in
                return model.fetchPosts(type: type).asDriver(onErrorJustReturn: nil)
            }
        }
}
