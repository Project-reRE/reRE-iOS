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
    
    func movieSetsEntityToModel(entity: [MovieSetsEntity]) -> [MovieSetsResponseModel] {
        return entity.map { movieSetsEntity -> MovieSetsResponseModel in
            let movieSetEntity: [MovieSetResponseModel] = movieSetsEntity.data.map { movieSetEntity -> MovieSetResponseModel in
                let directorsEntity: MovieDirectorResponseModel = movieDirectorEntityToModel(entity: movieSetEntity.directors)
                let actorsEntity: MovieActorResponseModel = movieActorEntityToModel(entity: movieSetEntity.actors)
                
                return MovieSetResponseModel(DOCID: movieSetEntity.DOCID,
                                             movieId: movieSetEntity.movieId,
                                             movieSeq: movieSetEntity.movieSeq,
                                             title: movieSetEntity.title,
                                             prodYear: movieSetEntity.prodYear,
                                             directors: directorsEntity,
                                             actors: actorsEntity,
                                             nation: movieSetEntity.nation,
                                             company: movieSetEntity.company,
                                             runtime: movieSetEntity.runtime,
                                             rating: movieSetEntity.rating,
                                             genre: movieSetEntity.genre,
                                             repRatDate: movieSetEntity.repRatDate,
                                             repRlsDate: movieSetEntity.repRlsDate,
                                             posters: movieSetEntity.posters,
                                             stlls: movieSetEntity.stlls)
            }
            
            return MovieSetsResponseModel(title: movieSetsEntity.title,
                                          template: movieSetsEntity.template,
                                          displayOrder: movieSetsEntity.displayOrder,
                                          condition: movieSetsEntity.condition,
                                          data: movieSetEntity)
        }
    }
    
    private func movieDirectorEntityToModel(entity: MovieDirectorEntity) -> MovieDirectorResponseModel {
        let director: [MovieDirectorDetailResponseModel] = entity.director.map { entity -> MovieDirectorDetailResponseModel in
            return movieDirectorDetailDataToEntity(entity: entity)
        }
        
        return MovieDirectorResponseModel(director: director)
    }
    
    private func movieDirectorDetailDataToEntity(entity: MovieDirectorDetailEntity) -> MovieDirectorDetailResponseModel {
        return MovieDirectorDetailResponseModel(directorNm: entity.directorNm,
                                                directorEnNm: entity.directorEnNm,
                                                directorId: entity.directorId)
    }
    
    private func movieActorEntityToModel(entity: MovieActorEntity) -> MovieActorResponseModel {
        let actor: [MovieActorDetailResponseModel] = entity.actor.map { entity -> MovieActorDetailResponseModel in
            return movieActorDetailEntityToModel(entity: entity)
        }
        
        return MovieActorResponseModel(actor: actor)
    }
    
    private func movieActorDetailEntityToModel(entity: MovieActorDetailEntity) -> MovieActorDetailResponseModel {
        return MovieActorDetailResponseModel(actorNm: entity.actorNm,
                                             actorEnNm: entity.actorEnNm,
                                             actorId: entity.actorId)
    }
}
