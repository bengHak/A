//
//  UpdatePostViewModel.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import Foundation
import RxSwift
import RxRelay

protocol UpdatePostDependency {
    var uploadPostDone: PublishRelay<Bool> { get }
}

protocol UpdatePostInput {
    var title: BehaviorSubject<String> { get }
    var content: BehaviorSubject<String> { get }
}

protocol UpdatePostOutput {

}

class UpdatePostViewModel {

    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    var input = Input()
    var dependency = Dependency()
    var output = Output()

    struct Input: UpdatePostInput {
        var title = BehaviorSubject<String>(value: "")
        var content = BehaviorSubject<String>(value: "")
    }

    struct Dependency: UpdatePostDependency {
        var uploadPostDone = PublishRelay<Bool>()
    }

    struct Output: UpdatePostOutput {

    }

}

// MARK: - UpdatePostService
extension UpdatePostViewModel: UpdatePostService {    

    func uploadPostContent(postId: Int, title: String, content: String) {
        updatePost(postId: postId, body: ModelUpdatePostRequest(title: title, content: content))
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                guard let response = result.response else {
                          print("🔴 upload a post failed")
                          return
                      }
                
                print(response)
                self.dependency.uploadPostDone.accept(true)
            })
            .disposed(by: bag)
    }
}
