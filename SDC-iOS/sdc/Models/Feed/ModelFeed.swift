//
//  ModelFeed.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation

struct ModelFeedResponse: APIResponse {
    var success: Bool?
    var msg: String?
    var data: [ModelFeed]?
}

struct ModelFeed: Codable {
    var id: Int?
    var userId: Int?
    var title: String?
    var content: String?
    var createdAt: Int?
    var updatedAt: Int?
}
