//
//  SearchCategoryView.swift
//  reRE
//
//  Created by chihoooon on 2024/05/15.
//

import UIKit
import SnapKit
import Then

protocol SearchCategoryViewDelegate: AnyObject {
    func didSelectCategory(_ category: SearchCategoryView.SearchCategoryType)
}

final class SearchCategoryView: UIView {
    weak var delegate: SearchCategoryViewDelegate?
    
    private lazy var containerView = TouchableView().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.masksToBounds = true
    }
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderateScale(number: 4)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = category.titleText
        $0.font = FontSet.title02.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = category.descriptionText
        $0.font = FontSet.subTitle01.font
    }
    
    private let category: SearchCategoryType
    
    init(category: SearchCategoryType) {
        self.category = category
        super.init(frame: .zero)
        
        addViews()
        makeConstraints()
        updateViews()
        
        containerView.didTapped { [weak self] in
            guard let self = self else { return }
            
            let containerBgColor = self.containerView.backgroundColor
            self.containerView.backgroundColor = containerBgColor?.withAlphaComponent(0.72)
            
            switch category {
            case .movie:
                self.imageView.tintColor = ColorSet.primary(.orange40).color
                self.titleLabel.textColor = ColorSet.primary(.orange80).color
                self.descriptionLabel.textColor = ColorSet.primary(.orange50).color
            case .book:
                break
            case .music:
                break
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.delegate?.didSelectCategory(category)
                
                self.imageView.tintColor = ColorSet.primary(.orange60).color
                self.titleLabel.textColor = ColorSet.gray(.white).color
                self.descriptionLabel.textColor = ColorSet.primary(.orange60).color
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([imageView, stackView])
        stackView.addArrangedSubviews([titleLabel, descriptionLabel])
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
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(moderateScale(number: 8))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
    }
    
    private func updateViews() {
        switch category {
        case .movie:
            containerView.backgroundColor = ColorSet.primary(.orange20).color
            descriptionLabel.textColor = ColorSet.primary(.orange60).color
            imageView.image = UIImage(named: "SearchMovieIcon")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = ColorSet.primary(.orange60).color
        case .book:
            containerView.backgroundColor = ColorSet.primary(.darkGreen20).color
            descriptionLabel.textColor = ColorSet.primary(.darkGreen60).color
            imageView.image = UIImage(named: "BookSearchIcon")
        case .music:
            containerView.backgroundColor = ColorSet.secondary(.cyan20).color
            descriptionLabel.textColor = ColorSet.secondary(.cyan60).color
            imageView.image = UIImage(named: "MusicSearchIcon")
        }
    }
}

extension SearchCategoryView {
    enum SearchCategoryType {
        case movie
        case book
        case music
        
        var titleText: String {
            switch self {
            case .movie:
                return "영화 찾기"
            case .book:
                return "도서 찾기"
            case .music:
                return "음반 찾기"
            }
        }
        
        var descriptionText: String {
            switch self {
            case .movie:
                return "개봉한지 5년이 지난 영화 평점 조회 및 재평가하기"
            case .book:
                return "출간한지 5년이 지난 도서 평점 조회 및 재평가하기"
            case .music:
                return "발매한지 5년이 지난 음반 평점 조회 및 재평가하기"
            }
        }
    }
}
