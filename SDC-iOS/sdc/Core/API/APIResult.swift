//
//  APIResult.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation

struct APIResult<T: Decodable> {
    var error: APIError?
    var response: T?
}
