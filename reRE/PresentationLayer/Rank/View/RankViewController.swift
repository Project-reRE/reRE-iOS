//
//  RankViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit
import SnapKit
import Then

final class RankViewController: BaseViewController {
    var coordinator: RankBaseCoordinator?
    
    private let bannerColorList: [UIColor?] = [ColorSet.primary(.orange60).color,
                                               ColorSet.primary(.darkGreen50).color,
                                               ColorSet.tertiary(.navy60).color]
    
    private lazy var rankingView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.registerCell(DailyRankingBannerCell.self)
        $0.backgroundColor = .clear
        $0.contentInsetAdjustmentBehavior = .never
        $0.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.gray(.gray10).color
    }
    
    override func addViews() {
        view.addSubview(rankingView)
    }
    
    override func makeConstraints() {
        rankingView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(getSafeAreaTop())
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemWidth: CGFloat = UIScreen.main.bounds.width - moderateScale(number: 48 * 2)
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                                  heightDimension: .absolute(moderateScale(number: 141)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                                   heightDimension: .absolute(moderateScale(number: 141)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = .zero
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = moderateScale(number: 8)
            return section
        }
    }
}

// MARK: - UICollectionViewDataSource
extension RankViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(DailyRankingBannerCell.self, indexPath: indexPath) else { return .init() }
        let order = indexPath.item % bannerColorList.count
        cell.updateView(title: "\(indexPath.item)", backgroundColor: bannerColorList[order])
        return cell
    }
}
