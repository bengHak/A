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
    
    func getUser(userId: Int) -> Observable<APIResult<ModelUserResponse>>
    
    func deletePostById(postId: Int) -> Observable<APIResult<ModelPostDeleteResponse>>
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
    
    func getUser(userId: Int) -> Observable<APIResult<ModelUserResponse>> {
        let url = UserEndpooint.profile(userId: userId).url
        
        let request = URLRequest.build(url: url,
                                       method: .get,
                                       body: [:])
        
        return apiSession.request(with: request)
    }
    
    func deletePostById(postId: Int) -> Observable<APIResult<ModelPostDeleteResponse>> {
        let url = PostEndpoint.post(postId: postId).url
        
        let request = URLRequest.build(url: url,
                                       method: .delete,
                                       body: [:],
                                       headers: tokenHeader)
        
        return apiSession.request(with: request)
    }
}
