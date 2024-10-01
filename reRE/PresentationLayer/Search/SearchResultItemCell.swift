//
//  SearchResultItemCell.swift
//  reRE
//
//  Created by chihoooon on 2024/06/02.
//

import UIKit
import SnapKit
import Then

final class SearchResultItemCell: UICollectionViewCell {
    lazy var containerView = TouchableView()
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.kf.indicatorType = .activity
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 4)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title03.font
    }
    
    private lazy var yearLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.body04.font
    }
    
    private lazy var genresLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.body04.font
    }
    
    private lazy var directorsLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.body04.font
    }
    
    private lazy var actorsLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.body04.font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([thumbnailImageView, titleLabel, yearLabel,
                                   genresLabel, directorsLabel, actorsLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(moderateScale(number: 74))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 4))
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(moderateScale(number: 14))
            $0.trailing.equalToSuperview()
        }
        
        yearLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 4))
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        genresLabel.snp.makeConstraints {
            $0.top.equalTo(yearLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        directorsLabel.snp.makeConstraints {
            $0.top.equalTo(genresLabel.snp.bottom).offset(moderateScale(number: 4))
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        actorsLabel.snp.makeConstraints {
            $0.top.equalTo(directorsLabel.snp.bottom).offset(moderateScale(number: 4))
            $0.leading.trailing.equalTo(titleLabel)
        }
    }
    
    func updateView(with model: SearchMovieListResultResponseModel) {
        titleLabel.text = model.data.title
        genresLabel.text = model.data.genre
        yearLabel.text = model.data.prodYear
        
        let directors = model.data.directors.map { $0.directorNm }.joined(separator: ", ")
        directorsLabel.text = directors
        
        let actors = model.data.actors.map { $0.actorNm }.joined(separator: ", ")
        actorsLabel.text = actors
        
        if let postersURLString = model.data.posters.first, postersURLString.isEmpty == false {
            thumbnailImageView.kf.setImage(with: URL(string: postersURLString))
        } else if let stillsURLString = model.data.stills.first, stillsURLString.isEmpty == false {
            thumbnailImageView.kf.setImage(with: URL(string: stillsURLString))
        } else {
            thumbnailImageView.image = UIImage(named: "DefaultThumbnail")
        }
    }
}
