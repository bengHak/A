//
//  CommentService.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import Foundation
import RxSwift

protocol CommentService: BaseService {
    
    func getComments(postId: Int) -> Observable<APIResult<ModelCommentsResponse>>
}

extension CommentService {
    
    func getComments(postId: Int) -> Observable<APIResult<ModelCommentsResponse>>{
        let url = PostEndpoint.comments(postId: postId).url
        
        let request = URLRequest.build(url: url,
                                       method: .get,
                                       body: [:])
        
        return apiSession.request(with: request)
    }
}
