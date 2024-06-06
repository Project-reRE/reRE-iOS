//
//  RankViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit
import SnapKit
import Then

struct RankingGenreProperty {
    let backgroundColor: UIColor?
    let textColor: UIColor?
    let descriptionColor: UIColor?
}

final class RankViewController: BaseViewController {
    var coordinator: RankBaseCoordinator?
    
    private let bannerColorList: [UIColor?] = [ColorSet.primary(.orange60).color,
                                               ColorSet.primary(.darkGreen50).color,
                                               ColorSet.tertiary(.navy60).color]
    
    private let genreProperties: [RankingGenreProperty] = [.init(backgroundColor: ColorSet.primary(.orange40).color,
                                                                 textColor: ColorSet.primary(.orange90).color,
                                                                 descriptionColor: ColorSet.primary(.orange60).color),
                                                           .init(backgroundColor: ColorSet.primary(.darkGreen40).color,
                                                                 textColor: ColorSet.primary(.darkGreen80).color,
                                                                 descriptionColor: ColorSet.primary(.darkGreen70).color),
                                                           .init(backgroundColor: ColorSet.secondary(.cyan50).color,
                                                                 textColor: ColorSet.gray(.white).color,
                                                                 descriptionColor: ColorSet.secondary(.cyan60).color)]
    
    private lazy var rankingView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.registerSupplimentaryView(DailyRankingHeaderView.self, supplementaryViewOfKind: .header)
        $0.registerCell(DailyRankingBannerCell.self)
        $0.registerSupplimentaryView(DailyRankingFooterView.self, supplementaryViewOfKind: .footer)
        $0.registerSupplimentaryView(GenreHeaderView.self, supplementaryViewOfKind: .header)
        $0.registerCell(RankingItemCell.self)
        $0.backgroundColor = .clear
        $0.contentInsetAdjustmentBehavior = .never
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 0, bottom: moderateScale(number: 48), right: 0)
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
            if sectionIndex == 0 {
                let itemWidth: CGFloat = UIScreen.main.bounds.width - moderateScale(number: 48 * 2)
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                                      heightDimension: .absolute(moderateScale(number: 141)))
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                                       heightDimension: .absolute(moderateScale(number: 141)))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets = .zero
                
                let section = NSCollectionLayoutSection(group: group)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(moderateScale(number: 82)))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(moderateScale(number: 54)))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                         elementKind: UICollectionView.elementKindSectionFooter,
                                                                         alignment: .bottom)
                section.boundarySupplementaryItems = [header, footer]
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = moderateScale(number: 8)
                section.contentInsets = .init(top: 0,
                                              leading: 0,
                                              bottom: moderateScale(number: 56),
                                              trailing: 0)
                return section
            } else {
                let itemWidth: CGFloat = UIScreen.main.bounds.width - moderateScale(number: 106 + 16)
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                                      heightDimension: .estimated(moderateScale(number: 165)))
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                                       heightDimension: .estimated(moderateScale(number: 165)))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets = .zero
                
                let section = NSCollectionLayoutSection(group: group)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(moderateScale(number: 49)))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = moderateScale(number: 12)
                section.contentInsets = .init(top: moderateScale(number: 11),
                                              leading: moderateScale(number: 16),
                                              bottom: moderateScale(number: 48),
                                              trailing: 0)
                return section
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension RankViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(DailyRankingBannerCell.self, indexPath: indexPath) else { return .init() }
            
            let order = indexPath.item % bannerColorList.count
            cell.updateView(title: "\(indexPath.item)", backgroundColor: bannerColorList[order])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(RankingItemCell.self, indexPath: indexPath) else { return .init() }
            
            cell.containerView.setOpaqueTapGestureRecognizer { [weak self] in
                self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.revaluationDetail), userData: nil)
            }
            
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let view = collectionView.dequeueSupplimentaryView(DailyRankingHeaderView.self, supplementaryViewOfKind: .header, indexPath: indexPath) else { return .init() }
                
                return view
            case UICollectionView.elementKindSectionFooter:
                guard let view = collectionView.dequeueSupplimentaryView(DailyRankingFooterView.self, supplementaryViewOfKind: .footer, indexPath: indexPath) else { return .init() }
                return view
            default:
                return .init()
            }
        } else {
            guard let view = collectionView.dequeueSupplimentaryView(GenreHeaderView.self, supplementaryViewOfKind: .header, indexPath: indexPath) else { return .init() }
            guard indexPath.section > 0 else { return .init() }
            let sectionIndex: Int = indexPath.section - 1
            let order: Int = sectionIndex % genreProperties.count
            view.updateView(property: genreProperties[order],
                            genreText: "\(sectionIndex)",
                            descriptionText: "가장 많은 재평가를 받은 영화 Top 3")
            return view
        }
    }
}
