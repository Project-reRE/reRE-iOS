//
//  Int+Extension.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import Foundation

extension Int {
    func formattedString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(for: self) ?? "\(self)"
    }
}
