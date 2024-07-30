//
//  HistoryViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit
import SnapKit
import Then

final class HistoryViewController: BaseViewController {
    var coordinator: HistoryBaseCoordinator?
    
    private lazy var topContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "히스토리"
        $0.font = FontSet.display02.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var movieHistoryView = HistoryCategoryView(category: .movie)
//    private lazy var bookHistoryView = HistoryCategoryView(category: .book)
//    private lazy var musicHistoryView = HistoryCategoryView(category: .music)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.gray(.gray10).color
    }
    
    override func addViews() {
        view.addSubviews([topContainerView, movieHistoryView])
        topContainerView.addSubview(titleLabel)
    }
    
    override func makeConstraints() {
        topContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(getSafeAreaTop())
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 44))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        movieHistoryView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 69))
        }
        
//        bookHistoryView.snp.makeConstraints {
//            $0.top.equalTo(movieHistoryView.snp.bottom).offset(moderateScale(number: 8))
//            $0.leading.trailing.equalTo(movieHistoryView)
//            $0.height.equalTo(moderateScale(number: 69))
//        }
//        
//        musicHistoryView.snp.makeConstraints {
//            $0.top.equalTo(bookHistoryView.snp.bottom).offset(moderateScale(number: 8))
//            $0.leading.trailing.equalTo(movieHistoryView)
//            $0.height.equalTo(moderateScale(number: 69))
//        }
    }
    
    override func setupIfNeeded() {
        movieHistoryView.containerView.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.history(.main), userData: nil)
        }
    }
}
