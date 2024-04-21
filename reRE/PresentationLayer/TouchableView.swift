//
//  TouchableView.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit

final class TouchableView: UIView {
    fileprivate var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    
    convenience init(_ vibrate: Bool = false) {
        self.init()
        self.impactFeedbackGenerator = vibrate ? UIImpactFeedbackGenerator(style: .light) : nil
    }
    
    private var effectColor: UIColor?
    
    convenience init(effectColor: UIColor?) {
        self.init()
        self.effectColor = effectColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setOpaqueTapGestureRecognizer(onTapped: @escaping () -> Void) {
        let gesture = TapGestureRecognizer(target: self, action: #selector(effect(gesture:)))
        gesture.onTapped = onTapped
        addGestureRecognizer(gesture)
    }
    
    @objc private func effect(gesture: TapGestureRecognizer) {
        guard gesture.onTapped != nil else { return }
        
        impactFeedbackGenerator?.impactOccurred()
        gesture.onTapped?()
    }
}
