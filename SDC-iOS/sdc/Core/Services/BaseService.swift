//
//  BaseService.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation
import SwiftKeychainWrapper

protocol BaseService {
    var apiSession: APIService { get }
}

extension BaseService {
    
    var token: String? {
        return KeychainWrapper.standard[.authToken]
    }
    
    var tokenHeader: [String: String?] {
        return [APIHeader.authToken.rawValue: token]
    }
}
