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
            return BannerResponseModel(displayOrder: entity.displayOrder,
                                       imageUrl: entity.imageUrl,
                                       route: entity.route)
        }
    }
    
    func movieSetsEntityToModel(entity: [MovieSetsEntity]) -> [MovieSetsResponseModel] {
        return entity.map { movieSetsEntity -> MovieSetsResponseModel in
            let movieSetEntity: [MovieSetResponseModel] = movieSetsEntity.data.map { movieSetEntity -> MovieSetResponseModel in
                let directorsResponseModel: [MovieDirectorDetailResponseModel] = movieDirectorDetailDataToEntity(entity: movieSetEntity.data.directors)
                let actorsResponseModel: [MovieActorDetailResponseModel] = movieActorDetailEntityToModel(entity: movieSetEntity.data.actors)
                
                return MovieSetResponseModel(id: movieSetEntity.id,
                                             data: .init(title: movieSetEntity.data.title,
                                                         genre: movieSetEntity.data.genre,
                                                         repRlsDate: movieSetEntity.data.repRlsDate,
                                                         directors: directorsResponseModel,
                                                         actors: actorsResponseModel,
                                                         posters: movieSetEntity.data.posters,
                                                         stills: movieSetEntity.data.stills))
            }
            
            return MovieSetsResponseModel(title: movieSetsEntity.title,
                                          genre: movieSetsEntity.genre,
                                          template: movieSetsEntity.template,
                                          displayOrder: movieSetsEntity.displayOrder,
                                          condition: movieSetsEntity.condition,
                                          data: movieSetEntity)
        }
    }
    
    private func movieDirectorDetailDataToEntity(entity: [MovieDirectorDetailEntity]) -> [MovieDirectorDetailResponseModel] {
        return entity.map { remoteItem -> MovieDirectorDetailResponseModel in
            return .init(directorNm: remoteItem.directorNm,
                         directorEnNm: remoteItem.directorEnNm,
                         directorId: remoteItem.directorId)
        }
    }
    
    private func movieActorDetailEntityToModel(entity: [MovieActorDetailEntity]) -> [MovieActorDetailResponseModel] {
        return entity.map { remoteItem -> MovieActorDetailResponseModel in
            return .init(actorNm: remoteItem.actorNm,
                         actorEnNm: remoteItem.actorEnNm,
                         actorId: remoteItem.actorId)
        }
    }
}
