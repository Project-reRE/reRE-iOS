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
    
    private lazy var historyListView = UICollectionView(frame: .zero, collectionViewLayout: StaggeredLayout()).then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.isHidden = true
        $0.registerCell(HistoryItemCell.self)
    }
    
    private lazy var noHistoryListView = NoHistoryListView().then {
        $0.isHidden = false
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
            $0.top.equalTo(topContainerView.snp.bottom).offset(moderateScale(number: 42))
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
            self?.viewModel.getPrevMonthHistoryList()
        }
        
        rightArrowButton.didTapped { [weak self] in
            self?.viewModel.getNextMonthHistoryList()
        }
        
        noHistoryListView.doRevaluateButton.didTapped { [weak self] in
            self?.navigationController?.popViewController(animated: false)
            self?.coordinator?.moveTo(appFlow: TabBarFlow.search(.search), userData: nil)
        }
    }
    
    private func bind() {
        viewModel.getHistoryListPublisher()
            .droppedSink { [weak self] historyList in
                if historyList.results.isEmpty {
                    self?.noHistoryListView.isHidden = false
                    self?.historyListView.isHidden = true
                } else {
                    self?.noHistoryListView.isHidden = true
                    self?.historyListView.isHidden = false
                    self?.historyListView.reloadData()
                }
            }.store(in: &cancelBag)
        
        viewModel.getShowingDateValue()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requestModel in
                let startDate = requestModel.startDate.toDate(with: "yyyy-MM-dd")
                let showingDate = startDate?.dateToString(with: "yyyy. MM")
                self?.dateLabel.text = showingDate
            }.store(in: &cancelBag)
    }
}

// MARK: - UICollectionViewDataSource
extension HistoryListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getHistoryListValue().results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(HistoryItemCell.self, indexPath: indexPath) else { return .init() }
        let historyData = viewModel.getHistoryListValue().results[indexPath.item]
        cell.updateView(with: historyData)
        
        cell.containerView.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.revaluationDetail),
                                      userData: ["movieId": historyData.id])
        }
        return cell
    }
}
