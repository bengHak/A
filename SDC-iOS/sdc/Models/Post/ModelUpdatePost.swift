//
//  ModelUpdatePost.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import Foundation

struct ModelUpdatePostRequest: Codable {
    let title: String
    let content: String
}

struct ModelUpdatePostResponse: APIResponse {
    var success: Bool?
    var msg: String?
    var data: String?
}
