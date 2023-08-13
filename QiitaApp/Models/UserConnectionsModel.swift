import UIKit
import Alamofire
import RxSwift
import RxCocoa

final class UserConnectionsModel {
    
    func fetchPosts(type: UserConnectionType) -> Observable<[UserData]?> {
        return Observable.create { observer in
            let path = type.apiPath
            let request = AF.request(path)
                .responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        if let jsonData = data as? [[String: Any]] {
                            let users = jsonData.compactMap { UserData(with: $0) }
                            observer.onNext(users)
                        } else {
                            observer.onError(APIError.invalidResponse)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}