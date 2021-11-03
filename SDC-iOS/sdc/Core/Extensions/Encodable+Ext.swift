//
//  Encodable+Ext.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation

extension Encodable {
    
    func toJson() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
}
