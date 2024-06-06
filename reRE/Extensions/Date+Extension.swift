//
//  Date+Extension.swift
//  reRE
//
//  Created by chihoooon on 2024/06/06.
//

import Foundation

extension Date {
    func dateToString(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = .autoupdatingCurrent
        
        return dateFormatter.string(from: self)
    }
    
    var oneMonthBefore: Date? {
        return Calendar.autoupdatingCurrent.date(byAdding: .month, value: -1, to: self)
    }
    
    var oneMonthLater: Date? {
        return Calendar.autoupdatingCurrent.date(byAdding: .month, value: 1, to: self)
    }
}
