//
//  HistoryItemCell.swift
//  reRE
//
//  Created by 강치훈 on 7/30/24.
//

import UIKit
import Then
import SnapKit

final class HistoryItemCell: UICollectionViewCell {
    lazy var containerView = TouchableView().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = ColorSet.gray(.gray20).color?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.masksToBounds = true
    }
    
    private lazy var gradationView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "NormalTabBarIcon")
    }
    
    private lazy var startImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "GradeStar")?.withTintColor(ColorSet.primary(.orange60).color!,
                                                              renderingMode: .alwaysOriginal)
    }
    
    private lazy var gradationLayer = CAGradientLayer()
    
    private lazy var ratingLabel = UILabel().then {
        $0.font = FontSet.title03.font
        $0.textColor = ColorSet.gray(.white).color
        $0.text = "3.75"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setVerticalGradient()
    }
    
    private func setVerticalGradient() {
        guard let startColor = ColorSet.gray(.gray10).color?.withAlphaComponent(0),
              let endColor = ColorSet.gray(.gray10).color else {
            return
        }
        
        gradationView.layoutIfNeeded()
        gradationLayer.removeFromSuperlayer()
        
        gradationLayer.frame = gradationView.bounds
        gradationLayer.locations = [0.0, 1.0]
        gradationLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradationView.layer.addSublayer(gradationLayer)
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([posterImageView, gradationView, startImageView, ratingLabel])
        containerView.bringSubviewToFront(gradationView)
        containerView.bringSubviewToFront(startImageView)
        containerView.bringSubviewToFront(ratingLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        startImageView.snp.makeConstraints {
            $0.centerY.equalTo(ratingLabel)
            $0.trailing.equalTo(ratingLabel.snp.leading).offset(-moderateScale(number: 4))
            $0.size.equalTo(moderateScale(number: 16))
        }
        
        ratingLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(moderateScale(number: 9))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 12))
        }
    }
    
    func updateView(with data: MyHistoryEntityData) {
        if let posterUrl = data.movie.data.posters.first {
            posterImageView.kf.setImage(with: URL(string: posterUrl))
        } else if let stillUrl = data.movie.data.stlls.first {
            posterImageView.kf.setImage(with: URL(string: stillUrl))
        } else {
            posterImageView.image = nil
        }
        
        ratingLabel.text = data.numStars
    }
}
