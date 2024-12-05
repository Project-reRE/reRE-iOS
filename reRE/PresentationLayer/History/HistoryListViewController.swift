//
//  HistoryListViewController.swift
//  reRE
//
//  Created by 강치훈 on 7/30/24.
//

import UIKit
import Combine
import Then
import SnapKit

final class HistoryListViewController: BaseNavigationViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    var coordinator: HistoryBaseCoordinator?
    
    private lazy var dateLabel = UILabel().then {
        $0.font = FontSet.title02.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var leftArrowButton = TouchableImageView(frame: .zero).then {
        $0.image = UIImage(named: "LeftArrow")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var rightArrowButton = TouchableImageView(frame: .zero).then {
        $0.image = UIImage(named: "RightArrow")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var historyListView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.isHidden = true
        $0.registerCell(HistoryItemCell.self)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .absolute(moderateScale(number: 246)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(moderateScale(number: 246)))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(moderateScale(number: 15))
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = moderateScale(number: 15)
            
            return section
        }
    }
    
    private lazy var noHistoryListView = NoHistoryListView().then {
        $0.isHidden = true
    }
    
    private let viewModel: HistoryListViewModel
    
    init(viewModel: HistoryListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([leftArrowButton, dateLabel, rightArrowButton,
                          historyListView, noHistoryListView])
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        leftArrowButton.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 18))
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(leftArrowButton)
            $0.leading.equalTo(leftArrowButton.snp.trailing).offset(moderateScale(number: 8))
        }
        
        rightArrowButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(moderateScale(number: 8))
            $0.size.equalTo(moderateScale(number: 18))
        }
        
        historyListView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(moderateScale(number: 59))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.bottom.equalToSuperview().inset(getSafeAreaBottom())
        }
        
        noHistoryListView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        setNavigationTitle(with: "재평가한 영화 목록 보기")
        
        leftArrowButton.didTapped { [weak self] in
            guard let prevMonth = self?.viewModel.showingDateValue.startDate.toDate(with: "yyyy-MM-dd")?.oneMonthBefore,
                  StaticValues.openedMonth <= prevMonth else {
                return
            }
            
            CommonUtil.showLoadingView()
            self?.viewModel.getPrevMonthHistoryList()
        }
        
        rightArrowButton.didTapped { [weak self] in
            guard let nextMonth = self?.viewModel.showingDateValue.startDate.toDate(with: "yyyy-MM-dd")?.oneMonthLater,
                  Date() > nextMonth else {
                return
            }
            
            CommonUtil.showLoadingView()
            self?.viewModel.getNextMonthHistoryList()
        }
        
        noHistoryListView.doRevaluateButton.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.search), userData: nil)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(shouldUpdateRevaluationList),
                                               name: .revaluationDeleted,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(shouldUpdateRevaluationList),
                                               name: .revaluationAdded,
                                               object: nil)
    }
    
    override func deinitialize() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .revaluationDeleted,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .revaluationAdded,
                                                  object: nil)
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .mainSink { [weak self] error in
                self?.showBaseError(with: error)
            }.store(in: &cancelBag)
        
        let showingDatePublisher = viewModel.showingDatePublisher.dropFirst()
        let historyListPublisher = viewModel.historyListPublisher.dropFirst()
        
        showingDatePublisher
            .zip(historyListPublisher)
            .mainSink { [weak self] requestModel, historyList in
                CommonUtil.hideLoadingView()
                
                let startDate: Date = requestModel.startDate.toDate(with: "yyyy-MM-dd") ?? Date()
                let showingDate: String = startDate.dateToString(with: "yyyy. MM")
                self?.dateLabel.text = showingDate
                
                if historyList.results.isEmpty {
                    let endDate: Date = requestModel.endDate.toDate(with: "yyyy-MM-dd") ?? Date()
                    self?.noHistoryListView.updateView(canRevaluateMonth: endDate >= Date())
                    self?.noHistoryListView.isHidden = false
                    self?.historyListView.isHidden = true
                } else {
                    self?.noHistoryListView.isHidden = true
                    self?.historyListView.isHidden = false
                    self?.historyListView.reloadData()
                }
            }.store(in: &cancelBag)
        
        CommonUtil.showLoadingView()
        viewModel.fetchRevaluationHistories()
    }
    
    @objc
    private func shouldUpdateRevaluationList() {
        viewModel.fetchRevaluationHistories()
    }
}

// MARK: - UICollectionViewDataSource
extension HistoryListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.historyListValue.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(HistoryItemCell.self, indexPath: indexPath) else { return .init() }
        
        let historyData: MyHistoryEntityData = viewModel.historyListValue.results[indexPath.item]
        cell.updateView(with: historyData)
        
        cell.containerView.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.history(.revaluationHistory),
                                      userData: ["historyEntity": historyData])
        }
        
        return cell
    }
}
