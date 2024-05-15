//
//  HistoryCategoryView.swift
//  reRE
//
//  Created by chihoooon on 2024/05/15.
//

import UIKit
import Then
import SnapKit

final class HistoryCategoryView: UIView {
    lazy var containerView = TouchableView().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.masksToBounds = true
    }
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = category.titleText
        $0.font = FontSet.title02.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private let category: HistoryCategoryType
    
    init(category: HistoryCategoryType) {
        self.category = category
        super.init(frame: .zero)
        
        addViews()
        makeConstraints()
        updateViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([imageView, titleLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
            $0.size.equalTo(moderateScale(number: 32))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(moderateScale(number: 8))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
    }
    
    private func updateViews() {
        switch category {
        case .movie:
            containerView.backgroundColor = ColorSet.primary(.orange20).color
            imageView.image = UIImage(named: "MovieSearchIcon")
        case .book:
            containerView.backgroundColor = ColorSet.primary(.darkGreen20).color
            imageView.image = UIImage(named: "BookSearchIcon")
        case .music:
            containerView.backgroundColor = ColorSet.secondary(.cyan20).color
            imageView.image = UIImage(named: "MusicSearchIcon")
        }
    }
}

extension HistoryCategoryView {
    enum HistoryCategoryType {
        case movie
        case book
        case music
        
        var titleText: String {
            switch self {
            case .movie:
                return "재평가한 영화 목록 보기"
            case .book:
                return "재평가한 도서 목록 보기"
            case .music:
                return "재평가한 음반 목록 보기"
            }
        }
    }
}
