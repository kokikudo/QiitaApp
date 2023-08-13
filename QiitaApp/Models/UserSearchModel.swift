import UIKit
import Alamofire
import RxSwift
import RxCocoa

final class UserSearchModel {
    
    func fetchPosts(id: String) -> Observable<UserData?> {
        return Observable.create { observer in
            
            let request = AF.request("https://qiita.com/api/v2/users/\(id)")
                .responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        if
                            let jsonData = data as? [String: Any],
                            let post = UserData(with: jsonData) {
                            observer.onNext(post)
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
