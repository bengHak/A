//
//  ModelUpdatePost.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import Foundation
import RxSwift

protocol UpdatePostService: BaseService {
    
    func updatePost(postId: Int, body: ModelUpdatePostRequest) -> Observable<APIResult<ModelUpdatePostResponse>>
}

extension UpdatePostService {
    
    func updatePost(postId: Int, body: ModelUpdatePostRequest) -> Observable<APIResult<ModelUpdatePostResponse>>{
        let url = PostEndpoint.post(postId: postId).url
        
        let request = URLRequest.build(url: url,
                                       method: .put,
                                       body: body,
                                       headers: tokenHeader)
        
        return apiSession.request(with: request)
    }
}
