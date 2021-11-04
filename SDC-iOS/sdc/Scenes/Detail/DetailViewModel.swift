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
    /// 작성자 데이터
    var writer: PublishRelay<ModelUser?> { get }
}

class DetailViewModel {
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    var output = Output()

    
    struct Output: DetailOutput {
        var post = BehaviorRelay<ModelPost?>(value: nil)
        var writer = PublishRelay<ModelUser?>()
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
                
                // 사용자가 작성한 게시글일 경우
                if UserDefaults.standard.integer(forKey: "userId") == data.userId {
                    print("내가 쓴 글")
                }
            })
            .disposed(by: bag)
        
        output.post
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                guard data != nil else { return }
                guard let userId = data?.userId else {
                    print("🔴 user id error")
                    return
                }
                
                self.getUser(userId: userId)
                    .subscribe(onNext: { result in
                        guard let response = result.response,
                              let userData = response.data else {
                                  print("🔴 fetching user data failed")
                                  return
                              }
                        self.output.writer.accept(userData)
                    })
                    .disposed(by: self.bag)
                
            })
            .disposed(by: bag)
    }
    
    func deletePost(_ postId: Int) {
        deletePostById(postId: postId)
            .subscribe(onNext: { result in
                
                guard let response = result.response,
                      !(response.success ?? false) else {
                          print("🔴 deleting post failed")
                          return
                      }
                
                
            })
            .disposed(by: bag)
    }
}
