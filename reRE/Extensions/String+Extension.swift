//
//  String+Extension.swift
//  reRE
//
//  Created by chihoooon on 2024/06/06.
//

import Foundation

extension String {
    func toDate(with format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = .autoupdatingCurrent
        
        return dateFormatter.date(from: self)
    }
    
    func isValidNickname() -> Bool {
        let regex = "^[A-Za-z가-힣0-9]{2,15}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}
