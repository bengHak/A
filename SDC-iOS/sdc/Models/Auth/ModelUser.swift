//
//  ModelUser.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import Foundation

struct ModelUserResponse: APIResponse {
    var success: Bool?
    var msg: String?
    var data: ModelUser?
}

struct ModelUser: Codable {
    var id: Int?
    var username: String?
    var email: String?
    var blogTitle: String?
}
