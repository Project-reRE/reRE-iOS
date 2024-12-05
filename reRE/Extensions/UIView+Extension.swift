//
//  UIView+Extension.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit

extension UIView {
    func addSubviews<T: UIView>(_ subviews: [T]) {
        subviews.forEach { addSubview($0) }
    }
}
