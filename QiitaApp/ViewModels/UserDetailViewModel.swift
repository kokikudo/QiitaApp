import RxSwift
import RxCocoa
import UIKit

class UserDetailViewModel {
    
    let articleDataList: Driver<[ArticleData]?>
    let isLoading: Driver<Bool>

    init(
        input: (
            id: Observable<String>,
            fetchEvent: Observable<Void>
        )) {
            
            let model = UserDetailModel()
            
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
            
            let newArticleDataList = Observable
                .combineLatest(input.id, pageCount)
                .flatMapLatest({ (id, pageCount) in
                    return model.fetchPosts(id: id, pageCount: pageCount)
                })
                .compactMap { $0 }
            
            articleDataList = newArticleDataList
                .scan(into: [ArticleData](), accumulator: { (sum, data) in
                    sum?.append(contentsOf: data)
                })
                .asDriver(onErrorJustReturn: nil)
                .do(onNext: { _ in
                    isLoadingRelay.accept(false)
                })
        }
    
}
