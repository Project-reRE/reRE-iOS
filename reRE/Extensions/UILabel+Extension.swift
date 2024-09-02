//
//  UILabel+Extension.swift
//  reRE
//
//  Created by 강치훈 on 9/2/24.
//

import UIKit

extension UILabel {
    func highLightText(targetString: String?, color: UIColor?, font: UIFont?) {
        guard let targetString = targetString else { return }
        
        var attributedString: NSMutableAttributedString
        let fullText: String = text ?? ""
        
        if let attributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        } else {
            attributedString = NSMutableAttributedString(string: fullText)
        }
        
        let range = (fullText as NSString).range(of: targetString)
        
        if let color = color {
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
        
        if let font = font {
            attributedString.addAttribute(.font, value: font, range: range)
        }
        
        attributedText = attributedString
    }
}
