//
//  OtherRevaluationsViewController.swift
//  reRE
//
//  Created by 강치훈 on 9/7/24.
//

import UIKit
import Then
import SnapKit

final class OtherRevaluationsViewController: BaseNavigationViewController {
    var coordinator: CommonBaseCoordinator?
    
    private lazy var sortByLikesButton = SortButton().then {
        $0.titleLabel.text = "인기순"
        $0.updateView(isSelected: true)
    }
    
    private lazy var sortByDateButton = SortButton().then {
        $0.titleLabel.text = "최신순"
        $0.updateView(isSelected: false)
    }
    
    private lazy var otherRevaluationListView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private let viewModel: OtherRevaluationsViewModel
    
    init(viewModel: OtherRevaluationsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([sortByLikesButton, sortByDateButton])
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        sortByDateButton.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(moderateScale(number: 16))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        sortByLikesButton.snp.makeConstraints {
            $0.trailing.equalTo(sortByDateButton.snp.leading).offset(-moderateScale(number: 4))
            $0.centerY.equalTo(sortByDateButton)
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        setNavigationTitle(with: "다른 재평가 보기")
        
        sortByLikesButton.didTapped { [weak self] in
            self?.sortByLikesButton.updateView(isSelected: true)
            self?.sortByDateButton.updateView(isSelected: false)
        }
        
        sortByDateButton.didTapped { [weak self] in
            self?.sortByDateButton.updateView(isSelected: true)
            self?.sortByLikesButton.updateView(isSelected: false)
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(moderateScale(number: 216)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(moderateScale(number: 216)))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = moderateScale(number: 12)
            return section
        }
    }
}
