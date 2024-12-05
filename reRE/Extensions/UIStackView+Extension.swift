//
//  UIStackView+Extension.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
