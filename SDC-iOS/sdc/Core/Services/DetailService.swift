//
//  DetailService.swift
//  sdc
//
//  Created by byunghak on 2021/11/04.
//

import Foundation
import RxSwift

protocol DetailService: BaseService {
    
    func getPost(postId: Int) -> Observable<APIResult<ModelPostResponse>>
    
    
//    func getUsername(userId: Int) -> Observable<APIResult<ModelPostResponse>>
//    func getCommentCount(postId: Int) -> Observable<APIResult<ModelPostResponse>>
//    func getLikeCount(postId: Int)
    
}

extension DetailService {
    
    func getPost(postId: Int) -> Observable<APIResult<ModelPostResponse>> {
        let url = PostEndpoint.post(postId: postId).url
        
        let request = URLRequest.build(url: url,
                                       method: .get,
                                       body: [:])
        
        return apiSession.request(with: request)
    }
}
