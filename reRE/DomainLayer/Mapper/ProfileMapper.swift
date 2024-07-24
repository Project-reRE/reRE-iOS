//
//  ProfileMapper.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation

struct ProfileMapper {
    func myProfileEntityToModel(entity: MyProfileEntity) -> MyProfileResponseModel {
        return MyProfileResponseModel(id: entity.id,
                                      externalId: entity.externalId,
                                      nickName: entity.nickName,
                                      description: entity.description,
                                      profileUrl: entity.profileUrl,
                                      email: entity.email,
                                      provider: entity.provider,
                                      role: entity.role,
                                      gender: entity.gender,
                                      birthDate: entity.birthDate,
                                      createdAt: entity.createdAt,
                                      updatedAt: entity.updatedAt,
                                      deletedAt: entity.deletedAt)
    }
}
