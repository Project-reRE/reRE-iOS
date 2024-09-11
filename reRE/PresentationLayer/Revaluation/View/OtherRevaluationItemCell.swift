//
//  OtherRevaluationItemCell.swift
//  reRE
//
//  Created by 강치훈 on 9/7/24.
//

import UIKit
import Then
import SnapKit

final class OtherRevaluationItemCell: UICollectionViewCell {
    private lazy var userThumbnailView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 20)
    }
    
    private lazy var nicknameLabel = UILabel().then {
        $0.font = FontSet.title03.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var thumbsUpImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var likesCountLabel = UILabel().then {
        $0.font = FontSet.body04.font
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var revaluationLabel = UILabel().then {
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.gray80).color
        $0.numberOfLines = 0
    }
    
    private lazy var commentTitleView = UIView().then {
        $0.backgroundColor = ColorSet.secondary(.cyan30).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 12)
    }
    
    private lazy var commentTitleLabel = UILabel().then {
        $0.text = "작성한 영화 한 줄 평"
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.secondary(.cyan80).color
    }
    
    private lazy var commentLabel = UILabel().then {
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.gray80).color
        $0.numberOfLines = 0
    }
    
    private lazy var reportButton = TouchableImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ReportIcon")
    }
    
    private lazy var revaluatedDateLabel = UILabel().then {
        $0.text = "YYYY.MM.DD"
        $0.font = FontSet.label02.font
        $0.textColor = ColorSet.gray(.gray40).color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = moderateScale(number: 8)
        backgroundColor = ColorSet.gray(.gray20).color
        
        addViews()
        makeConstraints()
    }
    
    private func addViews() {
        addSubviews([userThumbnailView, nicknameLabel, thumbsUpImageView,
                     likesCountLabel, revaluationLabel, commentTitleView,
                     commentLabel, reportButton, revaluatedDateLabel])
        commentTitleView.addSubview(commentTitleLabel)
    }
    
    private func makeConstraints() {
        userThumbnailView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(moderateScale(number: 16))
            $0.size.equalTo(moderateScale(number: 40))
        }
        
        likesCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.centerY.equalTo(userThumbnailView)
        }
        
        thumbsUpImageView.snp.makeConstraints {
            $0.trailing.equalTo(likesCountLabel.snp.leading).offset(-moderateScale(number: 8))
            $0.centerY.equalTo(userThumbnailView)
            $0.size.equalTo(moderateScale(number: 16))
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userThumbnailView)
            $0.leading.equalTo(userThumbnailView.snp.trailing).offset(moderateScale(number: 8))
            $0.trailing.equalTo(thumbsUpImageView.snp.leading).offset(-moderateScale(number: 8))
        }
        
        revaluationLabel.snp.makeConstraints {
            $0.top.equalTo(userThumbnailView.snp.bottom).offset(moderateScale(number: 12))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        commentTitleView.snp.makeConstraints {
            $0.top.equalTo(revaluationLabel.snp.bottom).offset(moderateScale(number: 20))
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        commentTitleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 4))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 8))
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(commentTitleView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        reportButton.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(moderateScale(number: 20))
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
            $0.size.equalTo(moderateScale(number: 16))
            $0.bottom.equalToSuperview().inset(moderateScale(number: 12))
        }
        
        revaluatedDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(reportButton)
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(with model: OtherRevaluationEntity) {
        if model.isLiked {
            thumbsUpImageView.image = UIImage(named: "LikedThumbUpIcon")
            likesCountLabel.textColor = ColorSet.primary(.orange60).color
        } else {
            thumbsUpImageView.image = UIImage(named: "ThumbsUpIcon")
            likesCountLabel.textColor = ColorSet.gray(.gray60).color
        }
        
        userThumbnailView.kf.setImage(with: URL(string: model.user.profileUrl))
        nicknameLabel.text = model.user.nickName
        likesCountLabel.text = "\(model.statistics.numCommentLikes)"
        commentLabel.text = model.comment
        
        
        if let createdDate = model.createdAt.toDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")?.dateToString(with: "yyyy-MM-dd") {
            revaluatedDateLabel.text = createdDate
        } else {
            revaluatedDateLabel.text = nil
        }
        
        let rating: Double = model.numStars
        
        if let specialPoint = RevaluationCategoryView.CategoryType(rawValue: model.specialPoint),
           let pastFeelings = RevaluationCategoryView.CategoryType(rawValue: model.pastValuation),
           let currentFeelings = RevaluationCategoryView.CategoryType(rawValue: model.presentValuation) {
            
            revaluationLabel.text = "재평가 평점은 '\(rating)' 주목할 포인트는 '\(specialPoint.titleText)'\n과거에는 '\(pastFeelings.titleText)' 현재는 '\(currentFeelings.titleText)'이라고 평가했어요."
            revaluationLabel.highLightText(targetString: "'\(rating)'",
                                           color: ColorSet.tertiary(.navy80).color,
                                           font: FontSet.title03.font)
            
            revaluationLabel.highLightText(targetString: "'\(specialPoint.titleText)'",
                                           color: ColorSet.tertiary(.navy80).color,
                                           font: FontSet.title03.font)
            
            var pastHighlightingColor: UIColor?
            
            switch pastFeelings {
            case .planningIntent, .directorsDirection, .actingSkills,
                    .scenario, .ost, .socialIssues, .visualElement, .soundElement:
                break
            case .positive:
                pastHighlightingColor = ColorSet.secondary(.olive50).color
            case .negative:
                pastHighlightingColor = ColorSet.primary(.orange50).color
            case .notSure:
                pastHighlightingColor = ColorSet.secondary(.cyan60).color
            }
            
            revaluationLabel.highLightText(targetString: "'\(pastFeelings.titleText)'",
                                           color: pastHighlightingColor,
                                           font: FontSet.title03.font)
            
            var currentHighlightingColor: UIColor?
            
            switch currentFeelings {
            case .planningIntent, .directorsDirection, .actingSkills,
                    .scenario, .ost, .socialIssues, .visualElement, .soundElement:
                break
            case .positive:
                currentHighlightingColor = ColorSet.secondary(.olive50).color
            case .negative:
                currentHighlightingColor = ColorSet.primary(.orange50).color
            case .notSure:
                currentHighlightingColor = ColorSet.secondary(.cyan60).color
            }
            
            revaluationLabel.highLightText(targetString: "'\(currentFeelings.titleText)'",
                                           color: currentHighlightingColor,
                                           font: FontSet.title03.font)
        } else {
            revaluationLabel.text = "재평가 평점은 '\(rating)' 주목할 포인트는 '???'\n과거에는 '???' 현재는 '???'이라고 평가했어요."
        }
    }
}
