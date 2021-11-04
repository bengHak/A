//
//  ModelPost.swift
//  sdc
//
//  Created by byunghak on 2021/11/04.
//

import Foundation

struct ModelPostResponse: APIResponse {
    var success: Bool?
    var msg: String?
    var data: ModelPost?
}

struct ModelPost: Codable {
    var id: Int?
    var userId: Int?
    var title: String?
    var content: String?
    var createdAt: Int?
    var updatedAt: Int?
}
