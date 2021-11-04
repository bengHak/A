//
//  APIResponse.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation

protocol APIResponse: Codable {
    
    associatedtype DataType: Codable
    
    var success: Bool? { get }
    var msg: String? { get }
    var data: DataType? { get }
    
}
