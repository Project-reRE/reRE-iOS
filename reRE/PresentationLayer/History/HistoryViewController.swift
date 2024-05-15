//
//  HistoryViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit
import SnapKit

final class HistoryViewController: BaseViewController {
    var coordinator: HistoryBaseCoordinator?
    
    private lazy var movieHistoryView = HistoryCategoryView(category: .movie)
    private lazy var bookHistoryView = HistoryCategoryView(category: .book)
    private lazy var musicHistoryView = HistoryCategoryView(category: .music)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.gray(.gray10).color
    }
    
    override func addViews() {
        view.addSubviews([movieHistoryView, bookHistoryView, musicHistoryView])
    }
    
    override func makeConstraints() {
        movieHistoryView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 60) + getSafeAreaTop())
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 69))
        }
        
        bookHistoryView.snp.makeConstraints {
            $0.top.equalTo(movieHistoryView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalTo(movieHistoryView)
            $0.height.equalTo(moderateScale(number: 69))
        }
        
        musicHistoryView.snp.makeConstraints {
            $0.top.equalTo(bookHistoryView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalTo(movieHistoryView)
            $0.height.equalTo(moderateScale(number: 69))
        }
    }
    
    override func setupIfNeeded() {
        movieHistoryView.containerView.setOpaqueTapGestureRecognizer {
            
        }
        
        bookHistoryView.containerView.setOpaqueTapGestureRecognizer {
            
        }
        
        musicHistoryView.containerView.setOpaqueTapGestureRecognizer {
            
        }
    }
}
