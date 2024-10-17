//
//  AppSettingViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/05/15.
//

import UIKit
import Then
import SnapKit

final class AppSettingViewController: BaseNavigationViewController {
    var coordinator: MyPageBaseCoordinator?
    
    private lazy var settingMenuListView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.backgroundColor = .clear
        $0.contentInsetAdjustmentBehavior = .never
        $0.bounces = false
        $0.delegate = self
        $0.dataSource = self
        
        $0.registerCell(AppSettingMenuItemCell.self)
    }
    
    private lazy var appVersionLabel = UILabel().then {
        $0.font = FontSet.label01.font
        $0.textColor = ColorSet.secondary(.cyan50).color
        $0.text = "Ver. \(CommonUtil.appVersion)"
    }
    
    private lazy var deleteAccountButton = TouchableView().then {
        $0.backgroundColor = .clear
        $0.isHidden = !StaticValues.isLoggedIn.value
    }
    
    private lazy var deleteAccountLabel = UILabel().then {
        $0.text = "회원 탈퇴하기"
        $0.textColor = ColorSet.gray(.gray40).color
        $0.font = FontSet.button03.font
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([settingMenuListView, appVersionLabel, deleteAccountButton])
        deleteAccountButton.addSubview(deleteAccountLabel)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        settingMenuListView.snp.makeConstraints {
            let menuCount: Int = AppSettingMenu.allCases.count
            let spacingCount: Int = menuCount - 1
            let height: CGFloat = moderateScale(number: 52) * CGFloat(menuCount) + moderateScale(number: 8) * CGFloat(spacingCount)
            
            $0.top.equalTo(topContainerView.snp.bottom).offset(moderateScale(number: 64))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.greaterThanOrEqualTo(height)
        }
        
        appVersionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 30))
            $0.top.equalTo(settingMenuListView.snp.bottom).offset(moderateScale(number: 20))
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.top.equalTo(settingMenuListView.snp.bottom).offset(moderateScale(number: 12))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        deleteAccountLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        setNavigationTitle(with: "설정 보기")
        
        deleteAccountButton.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.myPage(.appSetting(.deleteAccount)), userData: nil)
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(moderateScale(number: 52)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(moderateScale(number: 52)))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = moderateScale(number: 8)
            return section
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AppSettingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppSettingMenu.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(AppSettingMenuItemCell.self, indexPath: indexPath) else { return .init() }
        cell.updateView(withTitle: AppSettingMenu.allCases[indexPath.item].titleText)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AppSettingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AppSettingMenuItemCell else { return }
        guard let menu = AppSettingMenu(rawValue: indexPath.item) else { return }
        
        cell.didTapCell()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            switch menu {
            case .servicePolicy:
                self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.web),
                                          userData: ["webViewType": WebViewType.serviceAgreement])
            case .privacyPolicy:
                self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.web),
                                          userData: ["webViewType": WebViewType.privacyPolicy])
            case .termsPolicy:
                self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.web),
                                          userData: ["webViewType": WebViewType.termsPolicy])
            case .openAPI:
                self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.web),
                                          userData: ["webViewType": WebViewType.openAPI])
            }
            
            cell.resetCellAttibute()
        }
    }
}
