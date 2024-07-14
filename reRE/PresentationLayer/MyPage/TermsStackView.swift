//
//  TermsStackView.swift
//  reRE
//
//  Created by 강치훈 on 7/14/24.
//

import UIKit
import Combine
import Then
import SnapKit

final class TermsStackView: TouchableStackView {
    private var cancelBag = Set<AnyCancellable>()
    private let checkPublisher = CurrentValueSubject<Bool, Never>(false)
    
    private lazy var checkBackgroundView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray20).color
        $0.layer.borderColor = ColorSet.gray(.gray40).color?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = moderateScale(number: 4)
        $0.layer.masksToBounds = true
    }
    
    private lazy var checkMarkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "CheckIcon")
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.gray60).color
    }
    
    lazy var showTermsButton = TouchableLabel().then {
        $0.text = "보기"
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.gray60).color
        $0.setUnderline()
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alignment = .center
        spacing = moderateScale(number: 8)
        
        addViews()
        makeConstraints()
        
        checkPublisher
            .sink { [weak self] isChecked in
                self?.checkMarkImageView.isHidden = !isChecked
                self?.checkBackgroundView.backgroundColor = isChecked ? ColorSet.primary(.orange60).color : ColorSet.gray(.gray20).color
            }.store(in: &cancelBag)
        
        didTapped { [weak self] in
            self?.checkPublisher.value.toggle()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addArrangedSubviews([checkBackgroundView, titleLabel, showTermsButton])
        checkBackgroundView.addSubview(checkMarkImageView)
    }
    
    private func makeConstraints() {
        checkBackgroundView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 16))
        }
    }
    
    func updateView(withTitle title: String) {
        titleLabel.text = title
    }
    
    func updateCheckImage(isChecked: Bool) {
        checkPublisher.send(isChecked)
    }
    
    func getCheckPublisher() -> AnyPublisher<Bool, Never> {
        return checkPublisher.eraseToAnyPublisher()
    }
    
    func getCheckedValue() -> Bool {
        return checkPublisher.value
    }
}
