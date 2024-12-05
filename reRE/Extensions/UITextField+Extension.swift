//
//  UITextField+Extension.swift
//  reRE
//
//  Created by chihoooon on 2024/06/02.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ padding: CGFloat = moderateScale(number: 8)) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func addRightPadding(_ padding: CGFloat = moderateScale(number: 8)) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setCustomPlaceholder(placeholder: String, color: UIColor?, font: UIFont?) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [.foregroundColor: color,
                                                                     .font: font])
    }
}
