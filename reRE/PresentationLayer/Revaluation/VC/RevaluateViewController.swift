//
//  RevaluateViewController.swift
//  reRE
//
//  Created by 강치훈 on 8/15/24.
//

import UIKit
import Combine
import Then
import SnapKit
import Cosmos

final class RevaluateViewController: BaseNavigationViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    var coordinator: CommonBaseCoordinator?
    
    private let commentPlaceholder: String = "작성한 한 줄 평에 부적절한 내용이 있을 경우, 사전 안내 없이 삭제될 수 있어요."
    private let commentCountLimit: Int = 100
    private var currentScrollOffsetY: CGFloat = 0
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.delaysContentTouches = false
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
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
    
    private lazy var revaluateButton = TouchableLabel().then {
        $0.text = "재평가 완료하기"
        $0.textAlignment = .center
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.button01.font
        $0.backgroundColor = ColorSet.primary(.orange50).color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.layer.masksToBounds = true
    }
    
    private lazy var revaluateTitleLabel = UILabel().then {
        $0.text = "지금은 몇 점 주시겠어요?"
        $0.font = FontSet.title01.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var ratingLabel = UILabel().then {
        $0.text = "0.00"
        $0.font = FontSet.display01.font
        $0.textColor = ColorSet.primary(.orange60).color
    }
    
    private lazy var ratingView: CosmosView = {
        var settings = CosmosSettings()
        settings.starSize = moderateScale(number: 28)
        settings.starMargin = moderateScale(number: 8)
        settings.fillMode = .half
        settings.filledImage = UIImage(named: "GradedStar")
        settings.emptyImage = UIImage(named: "GradeStar")
        settings.minTouchRating = 0.5
        settings.updateOnTouch = true
        
        let view = CosmosView(settings: settings)
        view.rating = 0
        return view
    }()
    
    private lazy var ratingDescriptionLabel = UILabel().then {
        $0.text = "재평가 평점을 등록해 주세요."
        $0.font = FontSet.body01.font
        $0.textColor = ColorSet.gray(.gray60).color
    }
    
    private lazy var specialPointTitleLabel = UILabel().then {
        $0.text = "이 영화의 주목 포인트는 무엇인가요?"
        $0.font = FontSet.title01.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var specialPointCategoryView = RevaluateSpecialPointView()
    
    private lazy var pastFeelingsTitleLabel = UILabel().then {
        $0.text = "개봉 당시, 이 영화는 어땠나요?"
        $0.font = FontSet.title01.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var pastFeelingsCategoryView = RevaluateFeelingsView()
    
    private lazy var currentFeelingsTitleLabel = UILabel().then {
        let currentMonthString = Date().dateToString(with: "MM")
        
        if let currentMonth = Int(currentMonthString) {
            $0.text = "\(currentMonth)월에 이 영화는 어땠나요?"
        } else {
            $0.text = "이 영화는 어땠나요?"
        }
        
        $0.font = FontSet.title01.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var currentFeelingsCategoryView = RevaluateFeelingsView()
    
    private lazy var commentTitleLabel = UILabel().then {
        $0.text = "영화에 대한 한 줄 평을 남겨주세요."
        $0.font = FontSet.title01.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var commnetTextView = UITextView().then {
        $0.text = commentPlaceholder
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.gray50).color
        $0.textContainerInset = .init(top: moderateScale(number: 20),
                                      left: moderateScale(number: 16),
                                      bottom: moderateScale(number: 66),
                                      right: moderateScale(number: 16))
        $0.delegate = self
    }
    
    private lazy var commentCountLabel = UILabel().then {
        $0.text = "0/\(commentCountLimit)"
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray60).color
    }
    
    private let viewModel: RevaluateViewModel
    
    init(viewModel: RevaluateViewModel) {
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
                                   revaluateTitleLabel, ratingLabel, ratingView, ratingDescriptionLabel,
                                   specialPointTitleLabel, specialPointCategoryView,
                                   pastFeelingsTitleLabel, pastFeelingsCategoryView,
                                   currentFeelingsTitleLabel, currentFeelingsCategoryView,
                                   commentTitleLabel, commnetTextView, commentCountLabel])
        productDetailView.addSubviews([genreLabel, directorLabel, actorLabel, sourceLabel])
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        revaluateButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(getDefaultSafeAreaBottom())
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 52))
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(revaluateButton.snp.top).offset(-moderateScale(number: 10))
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
        
        revaluateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(productDetailView.snp.bottom).offset(moderateScale(number: 54))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(revaluateTitleLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.centerX.equalToSuperview()
        }
        
        ratingView.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.centerX.equalToSuperview()
        }
        
        ratingDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(ratingView.snp.bottom).offset(moderateScale(number: 16))
            $0.centerX.equalToSuperview()
        }
        
        specialPointTitleLabel.snp.makeConstraints {
            $0.top.equalTo(ratingDescriptionLabel.snp.bottom).offset(moderateScale(number: 48))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        specialPointCategoryView.snp.makeConstraints {
            $0.top.equalTo(specialPointTitleLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 32))
        }
        
        pastFeelingsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(specialPointCategoryView.snp.bottom).offset(moderateScale(number: 48))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        pastFeelingsCategoryView.snp.makeConstraints {
            $0.top.equalTo(pastFeelingsTitleLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 32))
        }
        
        currentFeelingsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(pastFeelingsCategoryView.snp.bottom).offset(moderateScale(number: 48))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        currentFeelingsCategoryView.snp.makeConstraints {
            $0.top.equalTo(currentFeelingsTitleLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 32))
        }
        
        commentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(currentFeelingsCategoryView.snp.bottom).offset(moderateScale(number: 48))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        commnetTextView.snp.makeConstraints {
            $0.top.equalTo(commentTitleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 122))
            $0.bottom.equalToSuperview().inset(moderateScale(number: 62))
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(commnetTextView).inset(moderateScale(number: 16))
            $0.bottom.equalTo(commnetTextView).inset(moderateScale(number: 20))
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        setNavigationTitle(with: "재평가하기")
        
        updateMovieInfo(withModel: viewModel.getMovieEntity().data)
        
        ratingView.didTouchCosmos = { [weak self] rating in
            self?.ratingLabel.text = "\(rating)"
            self?.viewModel.updateRating(to: rating)
        }
        
        specialPointCategoryView.planningIntentView.didTapped { [weak self] in
            self?.updateSpecialCategoryView(to: .planningIntent)
            self?.viewModel.updateSpecialPoint(with: .planningIntent)
        }
        
        specialPointCategoryView.directorsDirectionView.didTapped { [weak self] in
            self?.updateSpecialCategoryView(to: .directorsDirection)
            self?.viewModel.updateSpecialPoint(with: .directorsDirection)
        }
        
        specialPointCategoryView.actingSkillsView.didTapped { [weak self] in
            self?.updateSpecialCategoryView(to: .actingSkills)
            self?.viewModel.updateSpecialPoint(with: .actingSkills)
        }
        
        specialPointCategoryView.scenarioView.didTapped { [weak self] in
            self?.updateSpecialCategoryView(to: .scenario)
            self?.viewModel.updateSpecialPoint(with: .scenario)
        }
        
        specialPointCategoryView.visualElementView.didTapped { [weak self] in
            self?.updateSpecialCategoryView(to: .visualElement)
            self?.viewModel.updateSpecialPoint(with: .visualElement)
        }
        
        specialPointCategoryView.soundElementView.didTapped { [weak self] in
            self?.updateSpecialCategoryView(to: .soundElement)
            self?.viewModel.updateSpecialPoint(with: .soundElement)
        }
        
        specialPointCategoryView.ostView.didTapped { [weak self] in
            self?.updateSpecialCategoryView(to: .ost)
            self?.viewModel.updateSpecialPoint(with: .ost)
        }
        
        specialPointCategoryView.socialIssuesView.didTapped { [weak self] in
            self?.updateSpecialCategoryView(to: .socialIssues)
            self?.viewModel.updateSpecialPoint(with: .socialIssues)
        }
        
        pastFeelingsCategoryView.positiveView.didTapped { [weak self] in
            self?.updatePastFeelingsCategoryView(to: .positive)
            self?.viewModel.updatePastFeelings(with: .positive)
        }
        
        pastFeelingsCategoryView.negativeView.didTapped { [weak self] in
            self?.updatePastFeelingsCategoryView(to: .negative)
            self?.viewModel.updatePastFeelings(with: .negative)
        }
        
        pastFeelingsCategoryView.notSureView.didTapped { [weak self] in
            self?.updatePastFeelingsCategoryView(to: .notSure)
            self?.viewModel.updatePastFeelings(with: .notSure)
        }
        
        currentFeelingsCategoryView.positiveView.didTapped { [weak self] in
            self?.updateCurrentFeelingsCategoryView(to: .positive)
            self?.viewModel.updateCurrentFeelings(with: .positive)
        }
        
        currentFeelingsCategoryView.negativeView.didTapped { [weak self] in
            self?.updateCurrentFeelingsCategoryView(to: .negative)
            self?.viewModel.updateCurrentFeelings(with: .negative)
        }
        
        currentFeelingsCategoryView.notSureView.didTapped { [weak self] in
            self?.updateCurrentFeelingsCategoryView(to: .notSure)
            self?.viewModel.updateCurrentFeelings(with: .notSure)
        }
        
        revaluateButton.didTapped { [weak self] in
            guard let missingCategory = self?.viewModel.checkMissingCategory() else {
                self?.viewModel.revaluate()
                return
            }
            
            let alertText: String
            
            switch missingCategory {
            case .numStars:
                alertText = "평점은 0.5점부터 등록할 수 있어요."
            case .specialPoint:
                alertText = "이 영화의 주목할 포인트는 무엇인가요?"
            case .pastValuation:
                alertText = "이 영화, 과거엔 어땠는지 알려주세요.\n긍정적인가요? 부정적인가요?"
            case .presentValuation:
                alertText = "이 영화, 지금은 어떤지 알려주세요.\n긍정적인가요? 부정적인가요?"
            case .comment:
                alertText = "당신의 의견을 한 줄 평으로 들려주세요."
            }
            
            CommonUtil.showAlertView(withType: .default,
                                     buttonType: .oneButton,
                                     title: "재평가 완료하기",
                                     description: alertText,
                                     submitCompletion: nil,
                                     cancelCompletion: nil)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func deinitialize() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                
                LogDebug(error)
                
                if let userError = error as? UserError {
                    CommonUtil.showAlertView(withType: .default,
                                             buttonType: .oneButton,
                                             title: userError.message.first,
                                             description: error.localizedDescription,
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
        
        viewModel.getRevaluationSuccessPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancelBag)
    }
    
    private func updateMovieInfo(withModel model: SearchMovieListDataEntity) {
        if let postersURLString = model.posters.first, postersURLString.isEmpty == false {
            thumbnailImageView.kf.setImage(with: URL(string: postersURLString))
        } else if let stillsURLString = model.stills.first, stillsURLString.isEmpty == false {
            thumbnailImageView.kf.setImage(with: URL(string: stillsURLString))
        } else {
            thumbnailImageView.image = UIImage(named: "DefaultThumbnail")
        }
        
        yearLabel.text = model.prodYear
        titleLabel.text = model.title
        genreLabel.text = model.genre
        let directors = model.directors.map { $0.directorNm }.joined(separator: ", ")
        directorLabel.text = directors
        
        let actors = model.actors.map { $0.actorNm }.joined(separator: ", ")
        actorLabel.text = actors
    }
    
    private func updateCountLabel(characterCount: Int) {
        commentCountLabel.text = "\(characterCount)/\(commentCountLimit)"
    }
    
    private func updateSpecialCategoryView(to updatedCategory: RevaluationCategoryView.CategoryType) {
        specialPointCategoryView.subviews.forEach { subView in
            updateCategoryView(withView: subView, to: updatedCategory)
        }
    }
    
    private func updatePastFeelingsCategoryView(to updatedCategory: RevaluationCategoryView.CategoryType) {
        pastFeelingsCategoryView.subviews.forEach { subView in
            updateCategoryView(withView: subView, to: updatedCategory)
        }
    }
    
    private func updateCurrentFeelingsCategoryView(to updatedCategory: RevaluationCategoryView.CategoryType) {
        currentFeelingsCategoryView.subviews.forEach { subView in
            updateCategoryView(withView: subView, to: updatedCategory)
        }
    }
    
    private func updateCategoryView(withView subView: UIView, to updatedCategory: RevaluationCategoryView.CategoryType) {
        let categoryView = subView as? RevaluationCategoryView
        let category = categoryView?.getCategoryType()
        
        categoryView?.updateView(isSelected: category == updatedCategory)
    }
    
    @objc
    private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] keyboardFrame in
            guard let self = self else { return }
            guard let currentTextView = UIResponder.currentResponder as? UITextView else { return }
            
            let currentTextFieldFrame: CGRect = currentTextView.convert(currentTextView.bounds, to: self.view)
            
            if keyboardFrame.intersects(currentTextFieldFrame) {
                let offset: CGFloat = currentTextFieldFrame.maxY - keyboardFrame.minY + 10
                self.currentScrollOffsetY = self.scrollView.contentOffset.y
                self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y + offset), animated: true)
            }
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] _ in
            guard let self = self else { return }
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.currentScrollOffsetY), animated: true)
        }
    }
}

// MARK: - UITextViewDelegate
extension RevaluateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == commentPlaceholder else { return }
        
        textView.text = nil
        textView.textColor = ColorSet.gray(.white).color
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        textView.text = commentPlaceholder
        textView.textColor = ColorSet.gray(.gray50).color
        updateCountLabel(characterCount: 0)
        print(#function)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let comment = textView.text else { return false }
        viewModel.updateComment(with: comment)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: .newlines) == nil else {
            textView.resignFirstResponder()
            return false
        }
        
        guard let oldText = textView.text,
              let oldRange = Range(range, in: oldText) else {
            return true
        }
        
        let newText: String = oldText.replacingCharacters(in: oldRange, with: text)
        
        guard newText.count <= commentCountLimit else { return false }
        updateCountLabel(characterCount: newText.count)
        
        return true
    }
}
