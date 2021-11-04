//
//  CommentViewModel.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import Foundation
import RxSwift
import RxRelay

protocol CommentDependency {
    var isWritingDone: PublishRelay<Bool> { get }
}

protocol CommentInput {
    var comment: PublishSubject<String> { get }
}

protocol CommentOutput {
    var comments: BehaviorRelay<[ModelComment]?> { get }
}

class CommentViewModel {
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    var dependency = Dependency()
    var input = Input()
    var output = Output()

    struct Dependency: CommentDependency {
        var isWritingDone = PublishRelay<Bool>()
    }

    struct Input: CommentInput {
        var comment = PublishSubject<String>()
    }

    struct Output: CommentOutput {
        var comments = BehaviorRelay<[ModelComment]?>(value: [])
    }
}

// MARK: - CommentService
extension CommentViewModel: CommentService {
    
    func fetchComments(_ postId: Int) {
        getComments(postId: postId)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                guard let response = result.response,
                      let data = response.data else {
                          print("🔴 fetching comments failed")
                          return
                      }
                
                print(data)
                self.output.comments.accept(data)
            })
            .disposed(by: bag)
    }
    
    func newComment(_ postId: Int, comment: String) {
        writeComment(postId: postId, body: ModelWriteCommentRequest(content: comment))
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                guard let response = result.response else {
                          print("🔴 writing comment failed")          
                          return
                      }
                
                self.dependency.isWritingDone.accept(true)
            })
            .disposed(by: bag)
        
    }
}
