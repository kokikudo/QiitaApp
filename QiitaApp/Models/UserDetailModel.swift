import UIKit
import Alamofire
import RxSwift
import RxCocoa

final class UserDetailModel {
    func fetchPosts(id: String, completion: @escaping (Result<[ArticleData]?, Error>) -> Void) {
            let url = "https://qiita.com/api/v2/users/\(id)/items"
            
            AF.request(url).responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let jsonData = data as? [[String: Any]] {
                        let articles = jsonData.compactMap { ArticleData(with: $0) }
                        completion(.success(articles))
                    } else {
                        completion(.failure(APIError.invalidResponse))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
