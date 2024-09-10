//
//  RemoteSearchMapper.swift
//  reRE
//
//  Created by 강치훈 on 7/29/24.
//

import Foundation

struct RemoteSearchMapper {
    func remoteSearchItemToEntity(remoteItem: RemoteSearchMovieListItem) -> SearchMovieListEntity {
        guard let results = remoteItem.results else { return .init() }
        
        let searchMovieListResultEntity: [SearchMovieListResultEntity] = results.map { remoteResultItem -> SearchMovieListResultEntity in
            let movieDirectorsEntity = remoteResultItem.data?.directors?.compactMap {
                return MovieDirectorDetailEntity(directorNm: $0.directorNm ?? "",
                                                 directorEnNm: $0.directorEnNm ?? "",
                                                 directorId: $0.directorId ?? "")
            }
            
            let movieActorsEntity = remoteResultItem.data?.actors?.compactMap {
                return MovieActorDetailEntity(actorNm: $0.actorNm ?? "",
                                              actorEnNm: $0.actorEnNm ?? "",
                                              actorId: $0.actorId ?? "")
            }
            
            let searchMovieListDataEntity = SearchMovieListDataEntity(title: remoteResultItem.data?.title ?? "",
                                                                      prodYear: remoteResultItem.data?.prodYear ?? "",
                                                                      titrepRlsDatele: remoteResultItem.data?.titrepRlsDatele ?? "",
                                                                      directors: movieDirectorsEntity ?? [],
                                                                      actors: movieActorsEntity ?? [],
                                                                      rating: remoteResultItem.data?.rating ?? "",
                                                                      genre: remoteResultItem.data?.genre ?? "",
                                                                      posters: remoteResultItem.data?.posters ?? [],
                                                                      stills: remoteResultItem.data?.stills ?? [])
            
            return SearchMovieListResultEntity(id: remoteResultItem.id ?? "", data: searchMovieListDataEntity)
        }
        
        return SearchMovieListEntity(totalRecords: remoteItem.totalRecords ?? 0,
                                     results: searchMovieListResultEntity)
    }
}
