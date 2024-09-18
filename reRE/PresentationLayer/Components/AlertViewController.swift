//
//  AlertViewController.swift
//  reRE
//
//  Created by 강치훈 on 7/28/24.
//

import UIKit
import Then
import SnapKit

enum AlertButtonType {
    case oneButton
    case twoButton
}

enum AlertType {
    case `default`
    case textField
}

protocol AlertViewControllerDelegate: AnyObject {
    func textFieldDidChange(withText text: String)
}

final class AlertViewController: UIViewController {
    weak var delegate: AlertViewControllerDelegate?
    
    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.black).color?.withAlphaComponent(0.6)
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray20).color
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.clipsToBounds = true
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.spacing = moderateScale(number: 7.25)
        $0.distribution = .fillEqually
    }
    
    private(set) lazy var confirmButton = TouchableLabel().then {
        $0.text = "확인"
        $0.font = FontSet.button02.font
        $0.textColor = ColorSet.gray(.white).color
        $0.textAlignment = .center
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = ColorSet.primary(.orange50).color
        $0.layer.masksToBounds = true
    }
    
    private lazy var cancelButton = TouchableLabel().then {
        $0.text = "취소"
        $0.font = FontSet.button02.font
        $0.textColor = ColorSet.gray(.white).color
        $0.backgroundColor = ColorSet.tertiary(.navy40).color
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.masksToBounds = true
        $0.textAlignment = .center
    }
    
    private lazy var titleStackView = UIStackView().then {
        $0.spacing = moderateScale(number: 20)
        $0.axis = .vertical
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: moderateScale(number: 24),
                                        left: moderateScale(number: 16),
                                        bottom: moderateScale(number: 24),
                                        right: moderateScale(number: 16))
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = FontSet.title01.font
        $0.textColor = ColorSet.gray(.white).color
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.white).color
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var textFieldStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = moderateScale(number: 8)
        $0.isHidden = true
    }
    
    private lazy var textField = UITextField().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = ColorSet.gray(.gray30).color
        $0.addLeftPadding(moderateScale(number: 8))
        $0.addRightPadding(moderateScale(number: 8 + 20 + 8))
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        $0.delegate = self
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.white).color
        $0.setCustomPlaceholder(placeholder: "변경할 닉네임을 입력해 주세요. (2~15자)",
                                color: ColorSet.gray(.gray60).color,
                                font: FontSet.body03.font)
    }
    
    private lazy var clearButton = TouchableImageView(frame: .zero).then {
        $0.image = UIImage(named: "ClearButton")
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private lazy var textFieldDescriptionLabel = UILabel().then {
        $0.font = FontSet.subTitle01.font
        $0.numberOfLines = 0
    }
    
    private let alertButtonType: AlertButtonType
    private let alertType: AlertType
    
    init(alertButtonType: AlertButtonType, alertType: AlertType) {
        self.alertButtonType = alertButtonType
        self.alertType = alertType
        
        super.init(nibName: nil, bundle: nil)
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        view.addSubviews([backgroundView, containerView])
        containerView.addSubviews([titleStackView, buttonStackView])
        titleStackView.addArrangedSubviews([titleLabel, descriptionLabel])
        
        switch alertButtonType {
        case .oneButton:
            buttonStackView.addArrangedSubview(confirmButton)
        case .twoButton:
            buttonStackView.addArrangedSubviews([cancelButton, confirmButton])
        }
        
        switch alertType {
        case .default:
            break
        case .textField:
            titleStackView.addArrangedSubview(textFieldStackView)
            textFieldStackView.addArrangedSubviews([textField, textFieldDescriptionLabel])
            textField.addSubview(clearButton)
            clearButton.snp.makeConstraints {
                $0.top.trailing.bottom.equalToSuperview().inset(moderateScale(number: 8))
                $0.size.equalTo(moderateScale(number: 20))
            }
            
            textFieldStackView.isHidden = false
            
            confirmButton.isUserInteractionEnabled = false
            confirmButton.textColor = ColorSet.gray(.gray60).color
            confirmButton.backgroundColor = ColorSet.gray(.gray30).color
        }
    }
    
    private func makeConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 30))
            $0.center.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom)
            $0.height.equalTo(moderateScale(number: 44))
            $0.leading.trailing.bottom.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        if alertType == .textField {
            textField.snp.makeConstraints {
                $0.height.equalTo(moderateScale(number: 36))
            }
        }
    }
    
    func configureAlertView(withTitle title: String?,
                            description: String?,
                            delegate: AlertViewControllerDelegate? = nil,
                            submitText: String? = nil,
                            cancelText: String? = nil,
                            submitCompletion: (() -> Void)?,
                            cancelCompletion: (() -> Void)?) {
        confirmButton.didTapped { [weak self] in
            guard let submitCompletion = submitCompletion else {
                self?.dismiss(animated: false)
                return
            }
            
            submitCompletion()
        }
        
        cancelButton.didTapped { [weak self] in
            guard let cancelCompletion = cancelCompletion else {
                self?.dismiss(animated: false)
                return
            }
            
            cancelCompletion()
        }
        
        titleLabel.text = title
        
        if let description = description {
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }
        
        if let title = title {
            titleLabel.text = title
            
            if let description = description {
                descriptionLabel.text = description
            } else {
                descriptionLabel.isHidden = true
            }
        } else if let description = description {
            titleLabel.isHidden = true
            descriptionLabel.text = description
            titleStackView.layoutMargins = UIEdgeInsets(top: moderateScale(number: 32),
                                                        left: moderateScale(number: 16),
                                                        bottom: moderateScale(number: 24),
                                                        right: moderateScale(number: 16))
        }
        
        if let submitText = submitText {
            confirmButton.text = submitText
        }
        
        if let cancelText = cancelText {
            cancelButton.text = cancelText
        }
        
        self.delegate = delegate
        
        clearButton.didTapped { [weak self] in
            self?.textField.text = ""
            self?.clearButton.isHidden = true
            self?.delegate?.textFieldDidChange(withText: "")
        }
    }
    
    func updateTextFieldDescriptionLabel(withText text: String, isErrorOccured: Bool) {
        textFieldDescriptionLabel.text = text
        
        if isErrorOccured {
            textFieldDescriptionLabel.textColor = ColorSet.primary(.orange60).color
        } else {
            textFieldDescriptionLabel.textColor = ColorSet.primary(.darkGreen60).color
        }
    }
    
    @objc
    private func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        clearButton.isHidden = text.isEmpty
        delegate?.textFieldDidChange(withText: text)
    }
}

// MARK: - UITextFieldDelegate
extension AlertViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
