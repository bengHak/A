//
//  HomeService.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation
import RxSwift

protocol HomeService: BaseService {
    
    func getFeeds(pageNumber: Int) -> Observable<APIResult<ModelFeedResponse>>
}

extension HomeService {
    
    func getFeeds(pageNumber: Int) -> Observable<APIResult<ModelFeedResponse>> {
        let url = HomeEndpoint.feeds(pageNumber: pageNumber).url
        
        let request = URLRequest.build(url: url,
                                       method: .get,
                                       body: [:])
        
        return apiSession.request(with: request)
    }
}
