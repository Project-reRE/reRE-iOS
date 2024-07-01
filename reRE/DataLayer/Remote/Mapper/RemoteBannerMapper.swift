//
//  RemoteBannerMapper.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation

struct RemoteBannerMapper {
    func remoteBannerItemToEntity(remoteItem: RemoteBannerItem) -> [BannerEntity] {
        guard let bannerList = remoteItem.results else { return [] }
        return bannerList.map { remoteItem -> BannerEntity in
            return BannerEntity(title: remoteItem.title ?? "",
                                body: remoteItem.body ?? "",
                                template: remoteItem.template ?? "",
                                route: remoteItem.route ?? "",
                                boxHexCode: remoteItem.boxHexCode ?? "",
                                displayOrder: remoteItem.displayOrder ?? 0,
                                imageUrl: remoteItem.imageUrl ?? "",
                                display: remoteItem.display ?? false)
        }
    }
}
