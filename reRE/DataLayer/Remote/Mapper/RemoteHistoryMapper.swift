//
//  RemoteHistoryMapper.swift
//  reRE
//
//  Created by 강치훈 on 8/20/24.
//

import Foundation

struct RemoteHistoryMapper {
    func remoteMyHistoryItemToEntity(remoteItem: RemoteMyHistoryItem) -> MyHistoryEntity {
        guard let myHistoryResults = remoteItem.results else { return .init() }
        
        let myHistoryEntityData = myHistoryResults.map { remoteData -> MyHistoryEntityData in
            let movieDirectorsEntity = remoteData.movie?.data?.directors?.compactMap {
                return MovieDirectorDetailEntity(directorNm: $0.directorNm ?? "",
                                                 directorEnNm: $0.directorEnNm ?? "",
                                                 directorId: $0.directorId ?? "")
            }
            
            let movieActorsEntity = remoteData.movie?.data?.actors?.compactMap {
                return MovieActorDetailEntity(actorNm: $0.actorNm ?? "",
                                              actorEnNm: $0.actorEnNm ?? "",
                                              actorId: $0.actorId ?? "")
            }
            
            let movie = SearchMovieListResultEntity(id: remoteData.movie?.id ?? "",
                                                    data: SearchMovieListDataEntity(title: remoteData.movie?.data?.title ?? "",
                                                                                    prodYear: remoteData.movie?.data?.prodYear ?? "",
                                                                                    titrepRlsDatele: remoteData.movie?.data?.titrepRlsDatele ?? "",
                                                                                    directors: movieDirectorsEntity ?? [],
                                                                                    actors: movieActorsEntity ?? [],
                                                                                    rating: remoteData.movie?.data?.rating ?? "",
                                                                                    genre: remoteData.movie?.data?.genre ?? [],
                                                                                    posters: remoteData.movie?.data?.posters ?? [],
                                                                                    stills: remoteData.movie?.data?.stills ?? []))
            
            return MyHistoryEntityData(id: remoteData.id ?? "",
                                       numStars: remoteData.numStars ?? 0,
                                       specialPoint: remoteData.specialPoint ?? "",
                                       pastValuation: remoteData.pastValuation ?? "",
                                       presentValuation: remoteData.presentValuation ?? "",
                                       comment: remoteData.comment ?? "",
                                       createdAt: remoteData.createdAt ?? "",
                                       updatedAt: remoteData.updatedAt ?? "",
                                       deletedAt: remoteData.deletedAt ?? "",
                                       movie: movie)
        }
        
        return MyHistoryEntity(totalRecords: remoteItem.totalRecords ?? 0,
                               results: myHistoryEntityData)
    }
    
    func remoteMyHistoryDataToEntity(remoteItem: RemoteMyHistoryData) -> MyHistoryEntityData {
        return .init(id: remoteItem.id ?? "",
                     numStars: remoteItem.numStars ?? 0,
                     specialPoint: remoteItem.specialPoint ?? "",
                     pastValuation: remoteItem.pastValuation ?? "",
                     presentValuation: remoteItem.presentValuation ?? "",
                     comment: remoteItem.comment ?? "",
                     createdAt: remoteItem.createdAt ?? "",
                     updatedAt: remoteItem.updatedAt ?? "",
                     deletedAt: remoteItem.deletedAt ?? "",
                     movie: .init())
    }
}
