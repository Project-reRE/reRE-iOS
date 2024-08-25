//
//  RevaluationDetailViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/06/02.
//

import UIKit
import Combine
import SnapKit
import Then

final class RevaluationDetailViewController: BaseNavigationViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    var coordinator: CommonBaseCoordinator?
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var yearLabel = UILabel().then {
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray60).color
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title01.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var productDetailView = UIView().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.masksToBounds = true
        $0.backgroundColor = ColorSet.gray(.gray20).color
    }
    
    private lazy var genreLabel = UILabel().then {
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray60).color
    }
    
    private lazy var directorLabel = UILabel().then {
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray60).color
    }
    
    private lazy var actorLabel = UILabel().then {
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray60).color
    }
    
    private lazy var sourceLabel = UILabel().then {
        $0.text = "출처: KBDb"
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray40).color
    }
    
    private lazy var dividerView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray30).color
    }
    
    private lazy var dateLabel = UILabel().then {
        $0.font = FontSet.title02.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var leftArrowButton = TouchableImageView(frame: .zero).then {
        $0.image = UIImage(named: "LeftArrow")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var rightArrowButton = TouchableImageView(frame: .zero).then {
        $0.image = UIImage(named: "RightArrow")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var noRevaluationView = NoRevaluationView().then {
        $0.isHidden = true
    }
    
    private lazy var revaluationDetailView = RevaluationDetailView()
    
    private lazy var revaluateButton = TouchableLabel().then {
        $0.text = "재평가하기"
        $0.textAlignment = .center
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.button01.font
        $0.backgroundColor = ColorSet.primary(.orange50).color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.layer.masksToBounds = true
    }
    
    private let viewModel: ReValuationDetailViewModel
    
    init(viewModel: ReValuationDetailViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([scrollView, revaluateButton])
        scrollView.addSubview(containerView)
        containerView.addSubviews([thumbnailImageView, yearLabel, titleLabel, productDetailView,
                                   dividerView, dateLabel, leftArrowButton, rightArrowButton,
                                   noRevaluationView, revaluationDetailView])
        productDetailView.addSubviews([genreLabel, directorLabel, actorLabel, sourceLabel])
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        revaluateButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(getSafeAreaBottom())
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 52))
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(revaluateButton.snp.top)
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
        
        yearLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(moderateScale(number: 24))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(yearLabel.snp.bottom).offset(moderateScale(number: 11))
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 35))
        }
        
        productDetailView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        directorLabel.snp.makeConstraints {
            $0.top.equalTo(genreLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalTo(genreLabel)
        }
        
        actorLabel.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalTo(genreLabel)
        }
        
        sourceLabel.snp.makeConstraints {
            $0.top.equalTo(actorLabel.snp.bottom).offset(moderateScale(number: 12))
            $0.leading.bottom.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(productDetailView.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(1)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(moderateScale(number: 40))
            $0.centerX.equalToSuperview()
        }
        
        leftArrowButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.trailing.equalTo(dateLabel.snp.leading).offset(-moderateScale(number: 8))
            $0.size.equalTo(moderateScale(number: 18))
        }
        
        rightArrowButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(moderateScale(number: 8))
            $0.size.equalTo(moderateScale(number: 18))
        }
        
        noRevaluationView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.bottom.equalToSuperview().inset(moderateScale(number: 64))
        }
        
        revaluationDetailView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.bottom.equalToSuperview().inset(moderateScale(number: 64))
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        setNavigationTitle(with: "재평가 정보 보기")
        
        leftArrowButton.didTapped { [weak self] in
            self?.viewModel.getPrevMonthRevaluation()
        }
        
        rightArrowButton.didTapped { [weak self] in
            self?.viewModel.getNextMonthRevaluation()
        }
        
        revaluateButton.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.revaluate), userData: nil)
        }
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                LogDebug(error)
                
                if let userError = error as? UserError {
                    CommonUtil.showAlertView(withType: .default,
                                             buttonType: .oneButton,
                                             title: "(userError.statusCode)",
                                             description: userError.message.first,
                                             submitCompletion: nil,
                                             cancelCompletion: nil)
                } else {
                    CommonUtil.showAlertView(withType: .default,
                                             buttonType: .oneButton,
                                             title: error.localizedDescription,
                                             description: error.localizedDescription,
                                             submitCompletion: nil,
                                             cancelCompletion: nil)
                }
            }.store(in: &cancelBag)
        
        viewModel.getRevaluationDataPublisher()
            .droppedSink { [weak self] movieDetail in
                self?.updateMovieInfo(withModel: movieDetail.data)
                
                if let statistics = movieDetail.statistics.first {
                    self?.revaluationDetailView.updateGradeTrend(ratingsEntity: statistics.numRecentStars)
                    self?.revaluationDetailView.updateSpecialPoint(withModel: statistics.numSpecialPoint)
                    self?.revaluationDetailView.updateParticipantsView(withModel: statistics)
                }
            }.store(in: &cancelBag)
        
        viewModel.getShowingDateValue()
            .droppedSink { [weak self] showingRatingData in
                self?.dateLabel.text = showingRatingData.targetDate
                self?.revaluationDetailView.updateGradeView(withModel: showingRatingData)
            }.store(in: &cancelBag)
        
        viewModel.getRevaluationDetail()
    }
    
    private func updateMovieInfo(withModel model: SearchMovieListDataEntity) {
        if let postersURLString = model.posters.first, postersURLString.isEmpty == false {
            thumbnailImageView.kf.setImage(with: URL(string: postersURLString))
        } else if let stllsURLString = model.stlls.first, stllsURLString.isEmpty == false {
            thumbnailImageView.kf.setImage(with: URL(string: stllsURLString))
        } else {
            thumbnailImageView.image = nil
        }
        
        yearLabel.text = model.prodYear
        titleLabel.text = model.title
        genreLabel.text = model.genre
        let directors = model.directors.map { $0.directorNm }.joined(separator: ", ")
        directorLabel.text = directors
        
        let actors = model.actors.map { $0.actorNm }.joined(separator: ", ")
        actorLabel.text = actors
    }
}
