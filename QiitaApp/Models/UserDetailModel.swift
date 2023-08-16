import UIKit
import Alamofire
import RxSwift
import RxCocoa

final class UserDetailModel {
    func fetchPosts(id: String, pageCount: Int) -> Observable<[ArticleData]?> {
        return Observable.create { observer in
            let path = "https://qiita.com/api/v2/users/\(id)/items"
            let params = [
                "page": pageCount,
                "per_page": 20
            ]
            let request = AF.request(path, parameters: params)
                .responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        if let jsonData = data as? [[String: Any]] {
                            let articles = jsonData.compactMap { ArticleData(with: $0) }
                            observer.onNext(articles)
                        } else {
                            observer.onNext(nil)
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

