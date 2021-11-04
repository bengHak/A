//
//  ModelNewPost.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import Foundation

struct ModelNewPostRequest: Codable {
    let title: String
    let content: String
}

struct ModelNewPostResponse: APIResponse {
    var success: Bool?
    var msg: String?
    var data: String?
}
