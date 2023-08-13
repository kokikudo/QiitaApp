import RxSwift
import RxCocoa
import UIKit

class UserDetailViewModel {
    var dataEvent: Observable<[ArticleData]?> {
        return dataSubject.asObserver()
    }
    private let dataSubject = PublishSubject<[ArticleData]?>()
    private let disposeBag = DisposeBag()
    private var articles = [ArticleData]()
    
    var articlesReloadEvent: Observable<()> {
        return articlesReloadSubject.asObserver()
    }
    private let articlesReloadSubject = PublishSubject<()>()
    
    func getArticles() -> [ArticleData] {
        return articles
    }
    
    func fetchArticles(userId: String?) {
        guard let userId = userId else { return }
        let model = UserDetailModel()
        model.fetchPosts(id: userId) { result in
            switch result {
            case .success(let data):
                if let safeData = data {
                    self.articles = safeData
                    self.articlesReloadSubject.onNext(())
                }
            case .failure(_): break
                
            }
        
        }
    }
    
}
