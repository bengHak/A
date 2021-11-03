//
//  ModelVerify.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation

struct ModelVerifyRequest: Encodable {
    
}

struct ModelVerifyResponse: APIResponse {
    var success: Bool?
    var msg: String?
    var data: String?
}
