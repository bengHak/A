//
//  HomeViewModel.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeDependency {
    /// 페이지
    var pageNumber: BehaviorRelay<Int> { get }
    /// 다음 페이지 게시글 존재 여부
    var hasNext: BehaviorRelay<Bool> { get }
}

protocol HomeInput {
    
}

protocol HomeOutput {
    /// 피드 목록
    var feeds: BehaviorRelay<[ModelFeed]?> { get }
    /// 로그인 여부
    var isAuthenticated: PublishSubject<Bool> { get }
}

class HomeViewModel {
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    var dependency = Dependency()
    var output = Output()
    

    struct Dependency: HomeDependency {
        var pageNumber = BehaviorRelay<Int>(value: 1)
        var hasNext = BehaviorRelay<Bool>(value: false)
    }
    
    struct Output: HomeOutput {
        var feeds = BehaviorRelay<[ModelFeed]?>(value: [])
        var isAuthenticated = PublishSubject<Bool>()
    }
    
}

// HomeService
extension HomeViewModel: HomeService {
    
    func fetchFeeds(refresh: Bool = false, loadMore: Bool = false) {
        getFeeds(pageNumber: 1)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                guard let response = result.response,
                      let data = response.data else {
                          print("🔴 fetching feeds failed")
                          return
                      }
                
                let oldVal = self.output.feeds.value ?? []
                let newVal = oldVal + data
                self.output.feeds.accept(newVal)
                
            })
            .disposed(by: bag)
    }
}
