//
//  HistoryListViewController.swift
//  reRE
//
//  Created by 강치훈 on 7/30/24.
//

import UIKit
import Then
import SnapKit

final class HistoryListViewController: BaseNavigationViewController {
    var coordinator: HistoryBaseCoordinator?
    
    private lazy var historyListView = UICollectionView(frame: .zero, collectionViewLayout: StaggeredLayout()).then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.registerCell(HistoryItemCell.self)
    }
    
    private let viewModel: HistoryListViewModel
    
    init(viewModel: HistoryListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([historyListView])
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        historyListView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(moderateScale(number: 42))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.bottom.equalToSuperview().inset(getSafeAreaBottom())
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        setNavigationTitle(with: "재평가한 영화 목록 보기")
    }
}

// MARK: - UICollectionViewDataSource
extension HistoryListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(HistoryItemCell.self, indexPath: indexPath) else { return .init() }
        return cell
    }
}
