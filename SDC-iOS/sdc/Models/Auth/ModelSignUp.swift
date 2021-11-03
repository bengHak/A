//
//  ModelSignUp.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation

struct ModelSignUpRequest: Encodable {
    let email: String?
    let password: String?
    let username: String?
    let blog_title: String?
}

extension ModelSignUpRequest {
    init(email: String,
         password: String,
         username: String,
         blog_title: String) {
        self.email = email
        self.password = password
        self.username = username
        self.blog_title = blog_title
    }
}

struct ModelSignUpResponse: APIResponse {
    var success: Bool?
    var msg: String?
    var data: String?
}
