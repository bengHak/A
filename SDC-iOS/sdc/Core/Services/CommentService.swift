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
    
    func writeComment(postId: Int, body: ModelWriteCommentRequest) -> Observable<APIResult<ModelWriteCommentResponse>>
}

extension CommentService {
    
    func getComments(postId: Int) -> Observable<APIResult<ModelCommentsResponse>>{
        let url = PostEndpoint.comments(postId: postId).url
        
        let request = URLRequest.build(url: url,
                                       method: .get,
                                       body: [:])
        
        return apiSession.request(with: request)
    }
    
    func writeComment(postId: Int, body: ModelWriteCommentRequest) -> Observable<APIResult<ModelWriteCommentResponse>> {
        let url = PostEndpoint.writeComment(postId: postId).url
        
        let request = URLRequest.build(url: url,
                                       method: .post,
                                       body: body,
                                       headers: tokenHeader)
        
        return apiSession.request(with: request)
    }
}
