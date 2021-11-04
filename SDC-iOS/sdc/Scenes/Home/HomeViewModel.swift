//
//  HomeViewModel.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation
import RxSwift
import RxRelay
import SwiftKeychainWrapper

protocol HomeDependency {
    /// 페이지
    var pageNumber: BehaviorRelay<Int> { get }
    /// 다음 페이지 게시글 존재 여부
    var hasNext: BehaviorRelay<Bool> { get }
    /// 로그인 여부
    var isLogInNeeded: Bool { get }
}

protocol HomeInput {
    
}

protocol HomeOutput {
    /// 피드 목록
    var feeds: BehaviorRelay<[ModelFeed]?> { get }
}

class HomeViewModel {
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    var dependency = Dependency()
    var output = Output()
    

    struct Dependency: HomeDependency {
        var pageNumber = BehaviorRelay<Int>(value: 1)
        var hasNext = BehaviorRelay<Bool>(value: false)
        var isLogInNeeded: Bool {
            let token: String? = KeychainWrapper.standard[.authToken]
            return token == nil
        }
    }
    
    struct Output: HomeOutput {
        var feeds = BehaviorRelay<[ModelFeed]?>(value: [])
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
                
                if refresh {
                    self.output.feeds.accept(data)
                } else {
                    let oldVal = self.output.feeds.value ?? []
                    let newVal = oldVal + data
                    self.output.feeds.accept(newVal)
                }
                
            })
            .disposed(by: bag)
    }

    /*
        1. 글 쓰기 버튼 클릭
        2. 로그인 확인
            2-1. 로그인 X -> 로그인 하시겠습니까?
            2-2. 로그인 O -> 글쓰기 페이지로
     */
    
    /*
        1. 프로필 버튼 클릭
        2. 로그인 확인
            2-1. 로그인 X -> 로그인 화면
            2-2. 로그인 O -> 마이 페이지
     */
    func verifyAuthentication() {
        
    }
}
