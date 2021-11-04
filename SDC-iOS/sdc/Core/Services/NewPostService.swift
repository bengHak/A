//
//  NewPostService.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import Foundation
import RxSwift

protocol NewPostService: BaseService {
    
    func newPost(body: ModelNewPostRequest) -> Observable<APIResult<ModelNewPostResponse>>
}

extension NewPostService {
    
    func newPost(body: ModelNewPostRequest) -> Observable<APIResult<ModelNewPostResponse>>{
        let url = PostEndpoint.new.url
        
        let request = URLRequest.build(url: url,
                                       method: .post,
                                       body: body,
                                       headers: tokenHeader)
        
        return apiSession.request(with: request)
    }
}
