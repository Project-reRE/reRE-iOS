//
//  SearchViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit
import SnapKit

final class SearchMainViewController: BaseViewController {
    var coordinator: SearchBaseCoordinator?
    
    private lazy var searchMovieView = SearchCategoryView(category: .movie)
    private lazy var searchBookView = SearchCategoryView(category: .book)
    private lazy var searchMusicView = SearchCategoryView(category: .music)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.gray(.gray10).color
    }
    
    override func addViews() {
        view.addSubviews([searchMovieView, searchBookView, searchMusicView])
    }
    
    override func makeConstraints() {
        searchMovieView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 60) + getSafeAreaTop())
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 69))
        }
        
        searchBookView.snp.makeConstraints {
            $0.top.equalTo(searchMovieView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalTo(searchMovieView)
            $0.height.equalTo(moderateScale(number: 69))
        }
        
        searchMusicView.snp.makeConstraints {
            $0.top.equalTo(searchBookView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalTo(searchMovieView)
            $0.height.equalTo(moderateScale(number: 69))
        }
    }
    
    override func setupIfNeeded() {
        searchMovieView.containerView.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.search(.search), userData: nil)
        }
        
        searchBookView.containerView.didTapped { [weak self] in
            self?.showToastMessageView(title: "아직 준비중이에요.")
        }
        
        searchMusicView.containerView.didTapped { [weak self] in
            self?.showToastMessageView(title: "아직 준비중이에요.")
        }
    }
}
