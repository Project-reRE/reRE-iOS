//
//  OtherRevaluationsViewController.swift
//  reRE
//
//  Created by 강치훈 on 9/7/24.
//

import UIKit
import Combine
import Then
import SnapKit

final class OtherRevaluationsViewController: BaseNavigationViewController {
    private var cancelBag = Set<AnyCancellable>()
    var coordinator: CommonBaseCoordinator?
    
    private lazy var noOtherRevaluationsView = NoOtherRevaluationsView().then {
        $0.isHidden = true
    }
    
    private lazy var sortByLikesButton = SortButton().then {
        $0.titleLabel.text = "인기순"
        $0.updateView(isSelected: true)
        $0.isHidden = true
    }
    
    private lazy var sortByDateButton = SortButton().then {
        $0.titleLabel.text = "최신순"
        $0.updateView(isSelected: false)
        $0.isHidden = true
    }
    
    private lazy var otherRevaluationListView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        $0.isHidden = true
        $0.registerCell(OtherRevaluationItemCell.self)
    }
    
    private let viewModel: OtherRevaluationsViewModel
    
    init(viewModel: OtherRevaluationsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([noOtherRevaluationsView, sortByLikesButton,
                          sortByDateButton, otherRevaluationListView])
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        noOtherRevaluationsView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        sortByDateButton.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(moderateScale(number: 16))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        sortByLikesButton.snp.makeConstraints {
            $0.trailing.equalTo(sortByDateButton.snp.leading).offset(-moderateScale(number: 4))
            $0.centerY.equalTo(sortByDateButton)
        }
        
        otherRevaluationListView.snp.makeConstraints {
            $0.top.equalTo(sortByDateButton.snp.bottom).offset(moderateScale(number: 12))
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(getSafeAreaBottom())
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        setNavigationTitle(with: "다른 재평가 보기")
        
        sortByLikesButton.didTapped { [weak self] in
            guard let self = self else { return }
            guard !self.viewModel.isPopularityOrder else { return }
            
            CommonUtil.showLoadingView()
            self.changeOrder()
        }
        
        sortByDateButton.didTapped { [weak self] in
            guard let self = self else { return }
            guard self.viewModel.isPopularityOrder else { return }
            
            CommonUtil.showLoadingView()
            self.changeOrder()
        }
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .mainSink { [weak self] error in
                self?.showBaseError(with: error)
            }.store(in: &cancelBag)
        
        viewModel.getOtherRevaluationsPublisher()
            .droppedSink { [weak self] list in
                CommonUtil.hideLoadingView()
                
                if list.isEmpty {
                    self?.noOtherRevaluationsView.isHidden = false
                    
                    self?.otherRevaluationListView.isHidden = true
                    self?.sortByLikesButton.isHidden = true
                    self?.sortByDateButton.isHidden = true
                } else {
                    self?.noOtherRevaluationsView.isHidden = true
                    
                    self?.otherRevaluationListView.isHidden = false
                    self?.otherRevaluationListView.reloadData()
                    self?.otherRevaluationListView.layoutIfNeeded()
                    self?.sortByLikesButton.isHidden = false
                    self?.sortByDateButton.isHidden = false
                }
            }.store(in: &cancelBag)
        
        CommonUtil.showLoadingView()
        viewModel.getOtherRevaluations()
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
            section.contentInsets = .init(top: 0, leading: moderateScale(number: 16), bottom: 0, trailing: moderateScale(number: 16))
            return section
        }
    }
    
    private func changeOrder() {
        viewModel.changeOrder()
        sortByDateButton.updateView(isSelected: !viewModel.isPopularityOrder)
        sortByLikesButton.updateView(isSelected: viewModel.isPopularityOrder)
    }
}

// MARK: - UICollectionViewDataSource
extension OtherRevaluationsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getOtherRevaluationsValue().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(OtherRevaluationItemCell.self, indexPath: indexPath) else { return .init() }
        
        let otherRevaluation: OtherRevaluationEntity = viewModel.getOtherRevaluationsValue()[indexPath.item]
        cell.updateView(with: otherRevaluation)
        
        cell.likeStackView.didTapped { [weak self] in
            guard StaticValues.isLoggedIn.value else {
                self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.login), userData: nil)
                return
            }
            
            self?.viewModel.updateRevaluationLikes(withId: otherRevaluation.id, isLiked: !otherRevaluation.isLiked)
        }
        
        cell.reportButton.didTapped { [weak self] in
            guard StaticValues.isLoggedIn.value else {
                self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.login), userData: nil)
                return
            }
            
            guard let topVC = CommonUtil.topViewController() else { return }
            guard !(topVC is ReportAlertViewController) else { return }
            
            CommonUtil.hideLoadingView()
            
            let reportVC = ReportAlertViewController()
            reportVC.configureAlertView { [weak self] in
                print("report !!!")
            }
            
            reportVC.modalPresentationStyle = .overFullScreen
            topVC.present(reportVC, animated: false)
        }
        
        return cell
    }
}
