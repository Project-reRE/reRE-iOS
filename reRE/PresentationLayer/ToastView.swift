//
//  ToastView.swift
//  reRE
//
//  Created by chihoooon on 2024/06/02.
//

import UIKit
import Then
import SnapKit

final class ToastView: UIView {
    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = ColorSet.tertiary(.navy80).color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.layer.masksToBounds = true
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray20).color
        $0.font = FontSet.label01.font
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(backgroundView)
        backgroundView.addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 14))
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}
