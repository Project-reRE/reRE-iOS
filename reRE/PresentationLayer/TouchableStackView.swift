//
//  TouchableStackView.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit

class TouchableStackView: UIStackView {
    fileprivate var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    
    convenience init(_ vibrate: Bool = false) {
        self.init()
        self.impactFeedbackGenerator = vibrate ? UIImpactFeedbackGenerator(style: .light) : nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        isUserInteractionEnabled = true
    }
    
    func didTapped(onTapped: @escaping () -> Void) {
        let gesture = TapGestureRecognizer(target: self, action: #selector(didTab(gesture:)))
        gesture.onTapped = onTapped
        addGestureRecognizer(gesture)
    }
    
    @objc private func didTab(gesture: TapGestureRecognizer) {
        impactFeedbackGenerator?.impactOccurred()
        gesture.onTapped?()
    }
}
