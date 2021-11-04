//
//  DetailViewModel.swift
//  sdc
//
//  Created by byunghak on 2021/11/04.
//

import Foundation
import RxSwift
import RxRelay

protocol DetailDependency {
    
}

protocol DetailInput {
    
}

protocol DetailOutput {
    /// 글 데이터
    var post: BehaviorRelay<ModelPost?> { get }
}

class DetailViewModel {
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    var output = Output()

    
    struct Output: DetailOutput {
        var post = BehaviorRelay<ModelPost?>(value: nil)
    }
    
    
}

// - MARK: DetailService
extension DetailViewModel: DetailService {
    
    func fetchPost(_ postId: Int) {
        getPost(postId: postId)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                guard let response = result.response,
                      let data = response.data else {
                          print("🔴 fetching post failed")
                          return
                      }
                
                self.output.post.accept(data)
            })
            .disposed(by: bag)
    }
}
