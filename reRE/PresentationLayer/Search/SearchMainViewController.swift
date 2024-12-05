//
//  SearchViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit
import Then
import SnapKit

final class SearchMainViewController: BaseViewController {
    var coordinator: SearchBaseCoordinator?
    
    private lazy var topContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "검색"
        $0.font = FontSet.display02.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var searchMovieView = SearchCategoryView(category: .movie).then {
        $0.delegate = self
    }
//    private lazy var searchBookView = SearchCategoryView(category: .book)
//    private lazy var searchMusicView = SearchCategoryView(category: .music)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.gray(.gray10).color
    }
    
    override func addViews() {
        view.addSubviews([topContainerView, searchMovieView])
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
        
        searchMovieView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 69))
        }
        
//        searchBookView.snp.makeConstraints {
//            $0.top.equalTo(searchMovieView.snp.bottom).offset(moderateScale(number: 8))
//            $0.leading.trailing.equalTo(searchMovieView)
//            $0.height.equalTo(moderateScale(number: 69))
//        }
//        
//        searchMusicView.snp.makeConstraints {
//            $0.top.equalTo(searchBookView.snp.bottom).offset(moderateScale(number: 8))
//            $0.leading.trailing.equalTo(searchMovieView)
//            $0.height.equalTo(moderateScale(number: 69))
//        }
    }
}

// MARK: - SearchCategoryViewDelegate
extension SearchMainViewController: SearchCategoryViewDelegate {
    func didSelectCategory(_ category: SearchCategoryView.SearchCategoryType) {
        switch category {
        case .movie:
            coordinator?.moveTo(appFlow: TabBarFlow.common(.search), userData: nil)
        case .book:
            break
        case .music:
            break
        }
    }
}
