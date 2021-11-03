//
//  BaseEndpoint.swift
//  sdc
//
//  Created by byunghak on 2021/11/02.
//

import Foundation

let baseURL = "http://127.0.0.1:3000/api"

protocol Endpoint {
    
    var prefix: String { get }
    
    var path: String { get }
    
    var urlString: String { get }
    
    var url: URL { get }
}

extension Endpoint {
    
    var urlString: String {
        return "\(baseURL)\(path)"
    }
    
    var url: URL {
        guard let url = URL(string: urlString) else {
            fatalError("🔴 Endpoint url: Invalid URL(\(urlString))")
        }
        return url
    }
}
