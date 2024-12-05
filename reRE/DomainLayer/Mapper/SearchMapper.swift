//
//  SearchMapper.swift
//  reRE
//
//  Created by 강치훈 on 7/29/24.
//

import Foundation

struct SearchMapper {
    func searchEntityToModel(entity: SearchMovieListEntity) -> SearchMovieListResponseModel {
        let searchMovieListResultResponseModel: [SearchMovieListResultResponseModel] = entity.results.map { entity -> SearchMovieListResultResponseModel in
            let movieDirectorsEntity = entity.data.directors.map {
                return MovieDirectorDetailResponseModel(directorNm: $0.directorNm,
                                                        directorEnNm: $0.directorEnNm,
                                                        directorId: $0.directorId)
            }
            
            let movieActorsEntity = entity.data.actors.map {
                return MovieActorDetailResponseModel(actorNm: $0.actorNm,
                                                     actorEnNm: $0.actorEnNm,
                                                     actorId: $0.actorId)
            }
            
            return SearchMovieListResultResponseModel(id: entity.id,
                                                      data: .init(title: entity.data.title,
                                                                  prodYear: entity.data.prodYear,
                                                                  titrepRlsDatele: entity.data.titrepRlsDatele,
                                                                  directors: movieDirectorsEntity,
                                                                  actors: movieActorsEntity,
                                                                  rating: entity.data.rating,
                                                                  genre: entity.data.genre ?? [],
                                                                  posters: entity.data.posters,
                                                                  stills: entity.data.stills))
        }
        
        return SearchMovieListResponseModel(totalRecords: entity.totalRecords,
                                            results: searchMovieListResultResponseModel)
    }
}
