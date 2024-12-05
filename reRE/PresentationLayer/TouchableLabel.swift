//
//  TouchableLabel.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit

final class TouchableLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUnderline() {
        guard let attributedString = self.mutableAttributedString(), let textColor = self.textColor else { return }
        
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: textColor, range: range)
        self.attributedText = attributedString
    }
    
    func removeUnderline() {
        guard let attributedString = self.mutableAttributedString() else { return }
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle(rawValue: 0), range: range)
        
        self.attributedText = attributedString
    }
    
    private func mutableAttributedString() -> NSMutableAttributedString? {
        guard let labelText = self.text, let labelFont = self.font else { return nil }
        
        var attributedString: NSMutableAttributedString?
        if let attributedText = self.attributedText {
            attributedString = attributedText.mutableCopy() as? NSMutableAttributedString
        } else {
            attributedString = NSMutableAttributedString(string: labelText,
                                                         attributes: [NSAttributedString.Key.font: labelFont])
        }
        
        return attributedString
    }
    
    func didTapped(setEffect: Bool? = true, onTapped: @escaping () -> Void) {
        let gesture = TapGestureRecognizer(target: self, action: #selector(blur(gesture:)))
        gesture.onTapped = onTapped
        addGestureRecognizer(gesture)
    }
    
    @objc private func blur(gesture: TapGestureRecognizer) {
        gesture.onTapped?()
    }
}
