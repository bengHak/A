//
//  Home.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation

enum HomeEndpoint {
    
    case feeds(pageNumber: Int)
    
}

extension HomeEndpoint: Endpoint {
    var prefix: String {
        return "/post"
    }
    
    var path: String {
        switch self {
        case .feeds(let pageNumber):
            return "\(prefix)/all/\(pageNumber)"
        }
    }
}
