//
//  HistoryItemCell.swift
//  reRE
//
//  Created by 강치훈 on 7/30/24.
//

import UIKit

final class HistoryItemCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
