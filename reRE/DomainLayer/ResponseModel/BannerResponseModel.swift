//
//  BannerResponseModel.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation

struct BannerResponseModel {
    let displayOrder: Int
    let imageUrl: String
    let route: String
    
    init(displayOrder: Int, imageUrl: String, route: String) {
        self.displayOrder = displayOrder
        self.imageUrl = imageUrl
        self.route = route
    }
    
    init() {
        displayOrder = 0
        imageUrl = ""
        route = ""
    }
}
