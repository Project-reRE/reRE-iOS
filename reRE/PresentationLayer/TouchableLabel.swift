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
    
    func setOpaqueTapGestureRecognizer(setEffect: Bool? = true, onTapped: @escaping () -> Void) {
        let gesture = TapGestureRecognizer(target: self, action: #selector(blur(gesture:)))
        gesture.onTapped = onTapped
        addGestureRecognizer(gesture)
    }
    
    @objc private func blur(gesture: TapGestureRecognizer) {
        gesture.onTapped?()
    }
}
