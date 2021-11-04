//
//  ModelComment.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import Foundation

struct ModelWriteCommentRequest: Codable {
    var content: String?
}

struct ModelWriteCommentResponse: APIResponse {
    var success: Bool?
    var msg: String?
    var data: String?
}

struct ModelCommentsResponse: APIResponse {
    var success: Bool?
    var msg: String?
    var data: [ModelComment]?
}

struct ModelComment: Codable {
    var commentId: Int?
    var userId: Int?
    var username: String? 
    var postId: Int?
    var content: String?
    var createdAt: Int?
}
