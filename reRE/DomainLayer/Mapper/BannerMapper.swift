//
//  BannerMapper.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation

struct BannerMapper {
    func bannerEntityToModel(entity: [BannerEntity]) -> [BannerResponseModel] {
        return entity.map { entity -> BannerResponseModel in
            return BannerResponseModel(title: entity.title,
                                       body: entity.body,
                                       template: entity.template,
                                       route: entity.route,
                                       boxHexCode: entity.boxHexCode,
                                       displayOrder: entity.displayOrder,
                                       imageUrl: entity.imageUrl,
                                       display: entity.display)
        }
    }
}
