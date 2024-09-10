//
//  RevaluationHistoryViewController.swift
//  reRE
//
//  Created by 강치훈 on 9/10/24.
//

import UIKit
import Then
import SnapKit

final class RevaluationHistoryViewController: BaseNavigationViewController {
    var coordinator: HistoryBaseCoordinator?
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var revaluationStackView = UIStackView().then {
        $0.alignment = .center
    }
    
    private lazy var starIcon = UIImageView().then {
        $0.image = UIImage(named: "GradedStar")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var ratingLabel = UILabel().then {
        $0.font = FontSet.title01.font
        $0.textColor = ColorSet.gray(.white).color
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var revaluateDateView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray20).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 4)
    }
    
    private lazy var revaluateDateLabel = UILabel().then {
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray50).color
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title01.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var revaluationDetailView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray20).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var revaluationDetailLabel = UILabel().then {
        $0.font = FontSet.body01.font
        $0.textColor = ColorSet.gray(.gray70).color
        $0.numberOfLines = 0
    }
    
    private lazy var revaluationCommentView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray20).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var commentTitleLabel = UILabel().then {
        $0.text = "[작성한 영화 한 줄 평]"
        $0.font = FontSet.title03.font
        $0.textColor = ColorSet.tertiary(.navy70).color
    }
    
    private lazy var commentLabel = UILabel().then {
        $0.font = FontSet.body01.font
        $0.textColor = ColorSet.gray(.gray70).color
        $0.numberOfLines = 0
    }
    
    private lazy var getMovieInfoButton = TouchableLabel().then {
        $0.text = "영화 정보 보기"
        $0.font = FontSet.button02.font
        $0.textColor = ColorSet.secondary(.olive50).color
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.borderColor = ColorSet.secondary(.olive40).color?.cgColor
        $0.layer.borderWidth = moderateScale(number: 1)
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = .clear
    }
    
    private lazy var editCommentButton = TouchableLabel().then {
        $0.text = "한 줄 평 수정하기"
        $0.font = FontSet.button01.font
        $0.textColor = ColorSet.gray(.white).color
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.backgroundColor = ColorSet.tertiary(.navy40).color
    }
    
    private lazy var deleteRevaluationButton = TouchableLabel().then {
        $0.text = "재평가 삭제하기"
        $0.font = FontSet.button02.font
        $0.textColor = ColorSet.gray(.gray60).color
        $0.textAlignment = .center
        $0.backgroundColor = .clear
    }
    
    private let historyEntity: MyHistoryEntityData
    
    init(historyEntity: MyHistoryEntityData) {
        self.historyEntity = historyEntity
        
        super.init()
        updateView()
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews([thumbnailImageView, revaluationStackView, titleLabel,
                                   revaluationDetailView, revaluationCommentView,
                                   getMovieInfoButton, editCommentButton, deleteRevaluationButton])
        
        revaluationStackView.addArrangedSubviews([starIcon, ratingLabel, revaluateDateView])
        revaluationStackView.setCustomSpacing(moderateScale(number: 4), after: starIcon)
        revaluationStackView.setCustomSpacing(moderateScale(number: 12), after: ratingLabel)
        
        revaluateDateView.addSubview(revaluateDateLabel)
        revaluationDetailView.addSubview(revaluationDetailLabel)
        revaluationCommentView.addSubviews([commentTitleLabel, commentLabel])
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalToSuperview().inset(getSafeAreaBottom())
        }
        
        containerView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 24))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(moderateScale(number: 164))
            $0.height.equalTo(moderateScale(number: 246))
        }
        
        revaluationStackView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(moderateScale(number: 24))
            $0.centerX.equalToSuperview()
        }
        
        starIcon.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 20))
        }
        
        revaluateDateLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 6))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 8))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(revaluationStackView.snp.bottom).offset(moderateScale(number: 25))
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 35))
        }
        
        revaluationDetailView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 29))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        revaluationDetailLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        revaluationCommentView.snp.makeConstraints {
            $0.top.equalTo(revaluationDetailView.snp.bottom).offset(moderateScale(number: 11))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        commentTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(commentTitleLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.bottom.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        getMovieInfoButton.snp.makeConstraints {
            $0.top.equalTo(revaluationCommentView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 44))
        }
        
        editCommentButton.snp.makeConstraints {
            $0.top.equalTo(getMovieInfoButton.snp.bottom).offset(moderateScale(number: 64))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 52))
        }
        
        deleteRevaluationButton.snp.makeConstraints {
            $0.top.equalTo(editCommentButton.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 44))
            
            if getSafeAreaBottom() == 0 {
                $0.bottom.equalToSuperview().inset(moderateScale(number: getDefaultSafeAreaBottom()))
            } else {
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        setNavigationTitle(with: "재평가한 내용 상세 보기")
    }
    
    private func updateView() {
        if let postersURLString = historyEntity.movie.data.posters.first, postersURLString.isEmpty == false {
            thumbnailImageView.kf.setImage(with: URL(string: postersURLString))
        } else if let stillsURLString = historyEntity.movie.data.stills.first, stillsURLString.isEmpty == false {
            thumbnailImageView.kf.setImage(with: URL(string: stillsURLString))
        } else {
            thumbnailImageView.image = UIImage(named: "DefaultThumbnail")
        }
        
        titleLabel.text = historyEntity.movie.data.title
        ratingLabel.text = historyEntity.numStars
        commentLabel.text = historyEntity.comment
        
        if let createdDate = historyEntity.createdAt.toDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")?.dateToString(with: "yyyy-MM-dd") {
            revaluateDateLabel.text = "\(createdDate) 평가"
        }
        
        if let specialPoint = RevaluationCategoryView.CategoryType(rawValue: historyEntity.specialPoint)?.titleText,
           let pastValuation = RevaluationCategoryView.CategoryType(rawValue: historyEntity.pastValuation)?.titleText,
           let presentValuation = RevaluationCategoryView.CategoryType(rawValue: historyEntity.presentValuation)?.titleText {
            revaluationDetailLabel.text = "재평가 평점은 \(historyEntity.numStars), 주목할 포인트는 '\(specialPoint)', 과거에는 '\(pastValuation)', 현재는 '\(presentValuation)'이라고 평가했어요."
            
            
            ["\(historyEntity.numStars)", "'\(specialPoint)'",
             "'\(pastValuation)'", "'\(presentValuation)'"]
                .forEach {
                    revaluationDetailLabel.highLightText(targetString: $0,
                                                         color: ColorSet.secondary(.olive50).color,
                                                         font: FontSet.title02.font)
                }
        }
    }
}
