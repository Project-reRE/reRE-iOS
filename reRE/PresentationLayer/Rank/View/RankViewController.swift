//
//  RankViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit
import Combine
import SnapKit
import Then

struct RankingGenreProperty {
    let backgroundColor: UIColor?
    let textColor: UIColor?
    let descriptionColor: UIColor?
}

final class RankViewController: BaseViewController {
    var coordinator: RankBaseCoordinator?
    
    private var cancelBag = Set<AnyCancellable>()
    
    private var currentAutoScrollIndex = 1
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
    
    private let viewModel: RankViewModel
    
    init(viewModel: RankViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.gray(.gray10).color
        
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.stopTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard viewModel.getBannerListValue().count > 1 else { return }
        viewModel.startTimer()
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
    
    private func bind() {
        viewModel.getErrorSubject()
            .sink { error in
                LogDebug(error)
            }.store(in: &cancelBag)
        
        viewModel.getTimerPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                self.currentAutoScrollIndex += 1
                
                if self.currentAutoScrollIndex == self.viewModel.getBannerListValue().count - 1 {
                    self.currentAutoScrollIndex = 1
                }
                
                self.rankingView.scrollToItem(at: IndexPath(item: self.currentAutoScrollIndex, section: 0),
                                              at: .left,
                                              animated: true)
            }.store(in: &cancelBag)
        
        let bannerListPublisher = viewModel.getBannerListPublisher().dropFirst()
        let movieSetsPublisher = viewModel.getMovieSetsPublisher().dropFirst()
        
        movieSetsPublisher
            .zip(bannerListPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movieSets, bannerList in
                self?.rankingView.reloadData()
                self?.rankingView.layoutIfNeeded()
                
                if bannerList.count > 1 {
                    self?.rankingView.scrollToItem(at: IndexPath(item: 1, section: 0),
                                                   at: .left,
                                                   animated: false)
                    self?.viewModel.startTimer()
                } else {
                    self?.viewModel.stopTimer()
                }
            }.store(in: &cancelBag)
        
        viewModel.getMovieSets()
        viewModel.getBannerList()
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            if sectionIndex == 0 {
                let sectionMargin: CGFloat = moderateScale(number: 48)
                
                let itemWidth: CGFloat = UIScreen.main.bounds.width - sectionMargin * 2
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
                section.visibleItemsInvalidationHandler = { [weak self] _, point, _ in
                    guard let maxIndex = self?.viewModel.getBannerListValue().indices.max() else {
                        return
                    }
                    
                    let page: Int = Int(round(point.x / itemWidth))
                    
                    self?.currentAutoScrollIndex = page
                    
                    if page == maxIndex {
                        self?.currentAutoScrollIndex = 1
                    }  else if page == 0 {
                        self?.currentAutoScrollIndex = maxIndex - 1
                    }
                }
                
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
        if section == 0 {
            return viewModel.getBannerListValue().count
        } else {
            let bannerSectionIndex: Int = viewModel.getBannerListValue().isEmpty ? 0 : 1
            let sectionIndex: Int = section - bannerSectionIndex
            return viewModel.getMovieSetsValue()[sectionIndex].data.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(DailyRankingBannerCell.self, indexPath: indexPath) else { return .init() }
            
            let bannerModel: BannerResponseModel = viewModel.getBannerListValue()[indexPath.item]
            cell.updateView(withModel: bannerModel)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(RankingItemCell.self, indexPath: indexPath) else { return .init() }
            
            let bannerSectionIndex: Int = viewModel.getBannerListValue().isEmpty ? 0 : 1
            let model: MovieSetResponseModel = viewModel.getMovieSetsValue()[indexPath.section - bannerSectionIndex].data[indexPath.item]
            cell.updateView(withModel: model)
            
            cell.containerView.didTapped { [weak self] in
                self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.revaluationDetail), userData: nil)
            }
            
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if viewModel.getBannerListValue().isEmpty && viewModel.getMovieSetsValue().isEmpty {
            return 0
        } else {
            let bannerSection: Int = viewModel.getBannerListValue().isEmpty ? 0 : 1
            return viewModel.getMovieSetsValue().count + bannerSection
        }
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
            let bannerSectionIndex: Int = viewModel.getBannerListValue().isEmpty ? 0 : 1
            
            view.updateView(property: genreProperties[order],
                            genreText: "\(sectionIndex)",
                            descriptionText: viewModel.getMovieSetsValue()[indexPath.section - bannerSectionIndex].title)
            return view
        }
    }
}
