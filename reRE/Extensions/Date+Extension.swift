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
    
    func startDayOfMonth() -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return calendar.date(from: components)
    }
    
    func startDayOfMonthString() -> String {
        return startDayOfMonth()?.dateToString(with: "yyyy-MM-dd") ?? ""
    }
    
    func endDayOfMonth() -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        
        let components: NSDateComponents = calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        
        return calendar.date(from: components as DateComponents)
    }
    
    func endDayOfMonthString() -> String {
        return endDayOfMonth()?.dateToString(with: "yyyy-MM-dd") ?? ""
    }
}
