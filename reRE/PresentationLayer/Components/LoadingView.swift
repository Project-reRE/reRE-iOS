//
//  LoadingView.swift
//  reRE
//
//  Created by 강치훈 on 10/26/24.
//

import UIKit
import Lottie
import Then
import SnapKit

final class LoadingView: UIView {
    private lazy var animationView = LottieAnimationView().then {
        $0.animation = .named("Loading")
        $0.loopMode = .loop
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = ColorSet.gray(.gray10).color?.withAlphaComponent(0.5)
        
        addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        animationView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
