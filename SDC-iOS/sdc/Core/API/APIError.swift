//
//  APIError.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation

enum APIError: Error {
    case decodingError
    case httpError(Int)
    case unknownError
}
