//
//  Auth.swift
//  sdc
//
//  Created by byunghak on 2021/11/02.
//

import Foundation

enum AuthEndpoint: String {
    
    case signin = "/signin"
    
    case signup = "/signup"
    
    case verify = "/verify"
}

extension AuthEndpoint: Endpoint {
    
    var prefix: String {
        return "/auth"
    }
    
    var path: String {
        return "\(prefix)\(rawValue)"
    }
    
}
