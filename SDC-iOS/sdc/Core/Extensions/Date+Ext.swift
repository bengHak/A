//
//  Date+Ext.swift
//  sdc
//
//  Created by byunghak on 2021/11/04.
//

import Foundation

extension Date {
    
    /// Int형 타임스탬프를 "yyyy.MM.dd"로 변환
    static func getDateStringFromTimestamp(_ timestamp: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return dateFormatter.string(from: date)
    }
}
