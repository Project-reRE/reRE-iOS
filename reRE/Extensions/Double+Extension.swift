//
//  Double+Extension.swift
//  reRE
//
//  Created by 강치훈 on 11/24/24.
//

import Foundation

extension Double {
    func formatToString() -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = .autoupdatingCurrent
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.roundingMode = .floor
        return numberFormatter.string(for: self) ?? String(self)
    }
}
