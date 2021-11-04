//
//  User.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import Foundation

enum UserEndpooint {
    
    case admin
    
    case profile(userId: Int)
    
    case profileImage
    
    case blogImage

}

extension UserEndpooint: Endpoint {
    
    var prefix: String {
        return "/user"
    }
    
    var path: String {
        switch self{
        case .admin:
            return "\(prefix)/admin"
        case .profile(let userId):
            return "\(prefix)/\(userId)/profile"
        case .profileImage:
            return "\(prefix)/me/profile-image"
        case .blogImage:
            return "\(prefix)/me/blog-image"
        }
    }
    
}
