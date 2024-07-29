//
//  SearchViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/06/02.
//

import UIKit
import Combine
import SnapKit
import Then

final class SearchViewController: BaseNavigationViewController {
    var coordinator: SearchBaseCoordinator?
    
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var textField = UITextField().then {
        $0.addLeftPadding()
        $0.addRightPadding(moderateScale(number: 8 + 20 + 8))
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.backgroundColor = ColorSet.gray(.gray20).color
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.white).color
        $0.setCustomPlaceholder(placeholder: "재평가할 영화 제목을 검색해보세요.",
                                color: ColorSet.gray(.gray50).color,
                                font: FontSet.body03.font)
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        $0.delegate = self
    }
    
    private lazy var clearButton = TouchableImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ClearButton")
        $0.isHidden = true
    }
    
    private lazy var searchDescriptionView = SearchDescriptionView().then {
        $0.updateView(withDescriptionType: .default)
    }
    
    private lazy var searchListView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.registerCell(SearchResultItemCell.self)
        $0.backgroundColor = .clear
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.isHidden = true
    }
    
    private let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([searchDescriptionView, searchListView])
        topContainerView.addSubviews([textField])
        textField.addSubview(clearButton)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(backButton.snp.trailing).offset(moderateScale(number: 8))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 36))
        }
        
        clearButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(moderateScale(number: 8))
            $0.size.equalTo(moderateScale(number: 20))
        }
        
        searchDescriptionView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        searchListView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(moderateScale(number: 28))
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(getSafeAreaBottom())
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        clearButton.didTapped { [weak self] in
            self?.textField.text = ""
            self?.clearButton.isHidden = true
            self?.resetListView()
        }
    }
    
    private func bind() {
        viewModel.getSearchResultPublisher()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchedResult in
                if searchedResult.isEmpty {
                    guard let searchedText = self?.textField.text else { return }
                    
                    self?.searchDescriptionView.updateView(withDescriptionType: .emptyList(searchedText: searchedText))
                    self?.searchDescriptionView.isHidden = false
                    self?.searchListView.isHidden = true
                } else {
                    self?.searchDescriptionView.isHidden = true
                    self?.searchListView.isHidden = false
                    self?.searchListView.reloadData()
                }
            }.store(in: &cancelBag)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(moderateScale(number: 111)))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(moderateScale(number: 111)))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = moderateScale(number: 8)
            section.contentInsets = .init(top: 0,
                                          leading: moderateScale(number: 16),
                                          bottom: 0,
                                          trailing: moderateScale(number: 16))
            return section
        }
    }
    
    private func resetListView() {
        searchDescriptionView.updateView(withDescriptionType: .default)
        searchDescriptionView.isHidden = false
        searchListView.isHidden = true
    }
    
    @objc
    private func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        clearButton.isHidden = text.isEmpty
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        textField.resignFirstResponder()
        
        if text.isEmpty {
            resetListView()
        } else {
            viewModel.searchMovie(withTitle: text)
        }
        
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getSearchResultValue().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SearchResultItemCell.self, indexPath: indexPath) else { return .init() }
        
        let searchedMovie = viewModel.getSearchResultValue()[indexPath.item]
        
        cell.updateView(with: searchedMovie)
        
        cell.containerView.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.revaluationDetail), userData: nil)
        }
        return cell
    }
}
