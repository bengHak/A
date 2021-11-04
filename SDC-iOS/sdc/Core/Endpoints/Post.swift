//
//  Post.swift
//  sdc
//
//  Created by byunghak on 2021/11/04.
//

import Foundation

enum PostEndpoint {
    
    case all(pageNumber: Int)
    
    case my(pageNumber: Int)
    
    case new
    
    /// get, put, delete
    case post(postId: Int)
    
    case like(postId: Int)
    
    case comments(postId: Int)
    
    case writeComment(postId: Int)
    
    /// put, delete
    case updateComment(postId: Int, commentId: Int)
    
}

extension PostEndpoint: Endpoint {
    var prefix: String {
        return "/post"
    }
    
    var path: String {
        switch self {
        case .all(let pageNumber):
            return "\(prefix)/all/\(pageNumber)"
        case .my(let pageNumber):
            return "\(prefix)/my/\(pageNumber)"
        case .new:
            return "\(prefix)/new"
        case .post(let postId):
            return "\(prefix)/\(postId)"
        case .like(let postId):
            return "\(prefix)/\(postId)/like"
        case .comments(let postId):
            return "\(prefix)/\(postId)/comments"
        case .writeComment(let postId):
            return "\(prefix)/\(postId)/comment"
        case .updateComment(let postId, let commentId):
            return "\(prefix)/\(postId)/comment/\(commentId)"
        }
    }
}
