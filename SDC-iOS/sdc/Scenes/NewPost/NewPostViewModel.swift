//
//  NewPostViewModel.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import Foundation
import RxSwift
import RxRelay

protocol NewPostDependency {
    var uploadPostDone: PublishRelay<Bool> { get }
}

protocol NewPostInput {
    var title: BehaviorSubject<String> { get }
    var content: BehaviorSubject<String> { get }
}

protocol NewPostOutput {

}

class NewPostViewModel {

    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    var input = Input()
    var dependency = Dependency()
    var output = Output()

    struct Input: NewPostInput {
        var title = BehaviorSubject<String>(value: "")
        var content = BehaviorSubject<String>(value: "")
    }

    struct Dependency: NewPostDependency {
        var uploadPostDone = PublishRelay<Bool>()
    }

    struct Output: NewPostOutput {

    }

}

// MARK: - NewPostService
extension NewPostViewModel: NewPostService {

    func uploadPost(title: String, content: String) {
        newPost(body: ModelNewPostRequest(title: title, content: content))
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
