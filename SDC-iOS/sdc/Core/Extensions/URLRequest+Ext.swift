//
//  URLRequest+Ext.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation

extension URLRequest {
    
    // 기본 헤더
    static var defaultHeader: [String: String?] {
        return [:]
    }
    
    /// JSON Request
    private mutating func jsonRequest() {
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    static func build<T: Encodable>(url: URL,
                                    method: HTTPMethod = .get,
                                    body: T? = nil,
                                    headers: [String: String?] = URLRequest.defaultHeader) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.jsonRequest()
        
        if let body = body {
            request.httpBody = body.toJson()
        }
        
        if !headers.isEmpty {
            headers.forEach { key, value in
                
                request.setValue(value, forHTTPHeaderField: key)
                
            }
        }
        
        return request
    }
    
    static func build(url: URL,
                      method: HTTPMethod = .get,
                      body: [String: Any?] = [:],
                      headers: [String: String?] = URLRequest.defaultHeader) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.jsonRequest()
        
        if !body.isEmpty {
            let data = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = data
        }
        
        if !headers.isEmpty {
            headers.forEach { key, value in
                
                request.setValue(value, forHTTPHeaderField: key)
                
            }
        }
        
        return request
    }
}
