//
//  RemoteProfileMapper.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation

struct RemoteProfileMapper {
    func remoteMyProfileItemToEntity(remoteItem: RemoteMyProfileItem) -> MyProfileEntity {
        return MyProfileEntity(id: remoteItem.id ?? "",
                               externalId: remoteItem.externalId ?? "",
                               nickName: remoteItem.nickName ?? "",
                               description: remoteItem.description ?? "",
                               profileUrl: remoteItem.profileUrl ?? "",
                               email: remoteItem.email ?? "",
                               provider: remoteItem.provider ?? "",
                               role: remoteItem.role ?? "",
                               gender: remoteItem.gender ?? true,
                               birthDate: remoteItem.birthDate ?? "",
                               createdAt: remoteItem.createdAt ?? "",
                               updatedAt: remoteItem.updatedAt ?? "",
                               deletedAt: remoteItem.deletedAt ?? "",
                               statistics: .init(id: remoteItem.statistics?.id ?? "",
                                                 numRevaluations: remoteItem.statistics?.numRevaluations ?? 0))
    }
}
