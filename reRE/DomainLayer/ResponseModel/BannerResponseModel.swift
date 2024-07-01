//
//  BannerResponseModel.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation

struct BannerResponseModel {
    let title: String
    let body: String
    let template: String
    let route: String
    let boxHexCode: String
    let displayOrder: Int
    let imageUrl: String
    let display: Bool
    
    init(title: String,
         body: String,
         template: String,
         route: String,
         boxHexCode: String,
         displayOrder: Int,
         imageUrl: String,
         display: Bool) {
        self.title = title
        self.body = body
        self.template = template
        self.route = route
        self.boxHexCode = boxHexCode
        self.displayOrder = displayOrder
        self.imageUrl = imageUrl
        self.display = display
    }
    
    init() {
        title = ""
        body = ""
        template = ""
        route = ""
        boxHexCode = ""
        displayOrder = 0
        imageUrl = ""
        display = false
    }
}
