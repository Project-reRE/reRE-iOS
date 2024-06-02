//
//  SearchDescriptionView.swift
//  reRE
//
//  Created by chihoooon on 2024/06/02.
//

import UIKit
import SnapKit
import Then

final class SearchDescriptionView: UIStackView {
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = FontSet.body01.font
        $0.textColor = ColorSet.gray(.gray60).color
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .vertical
        alignment = .center
        spacing = moderateScale(number: 16)
        
        addViews()
        makeConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addArrangedSubviews([imageView, descriptionLabel])
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 152))
        }
    }
    
    func updateView(withDescriptionType type: DescriptionType) {
        descriptionLabel.text = type.descriptionText
    }
}

extension SearchDescriptionView {
    enum DescriptionType {
        case `default`
        case emptyList(searchedText: String)
        
        var descriptionText: String {
            switch self {
            case .default:
                return "재평가할 영화를 검색해 보세요.\n개봉한지 5년이 지난 영화만 검색할 수 있어요."
            case .emptyList(let searchedText):
                return "'\(searchedText)'에 대한 검색 결과가 없어요.\n개봉연도로부터 5년이 지나지 않은 영화 같아요."
            }
        }
    }
}
