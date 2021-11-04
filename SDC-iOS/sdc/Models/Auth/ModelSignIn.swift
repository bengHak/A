//
//  ModelSignIn.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation

struct ModelSignInRequest: Encodable {
    let email: String?
    let password: String?
}

extension ModelSignInRequest {
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

struct ModelSignInResponse: APIResponse {
    var success: Bool?
    var msg: String?
    var data: ModelTokenResponse?
}

struct ModelTokenResponse: Codable {
    var token: String?
    var id: Int?
}
