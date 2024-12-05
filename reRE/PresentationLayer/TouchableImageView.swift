//
//  TouchableImageView.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit

final class TouchableImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isUserInteractionEnabled = true
    }
    
    func didTapped(onTapped: @escaping () -> Void) {
        let gesture = TapGestureRecognizer(target: self, action: #selector(blur(gesture:)))
        gesture.onTapped = onTapped
        addGestureRecognizer(gesture)
    }
    
    @objc private func blur(gesture: TapGestureRecognizer) {
        gesture.onTapped?()
    }
}
