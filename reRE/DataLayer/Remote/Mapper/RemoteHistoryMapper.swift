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
            let movie = SearchMovieListResultEntity(id: remoteData.movie?.id ?? "",
                                                    data: SearchMovieListDataEntity(title: remoteData.movie?.data?.title ?? "",
                                                                                    prodYear: remoteData.movie?.data?.prodYear ?? "",
                                                                                    titrepRlsDatele: remoteData.movie?.data?.titrepRlsDatele ?? "",
                                                                                    directors: [],
                                                                                    actors: [],
                                                                                    rating: remoteData.movie?.data?.rating ?? "",
                                                                                    genre: remoteData.movie?.data?.genre ?? "",
                                                                                    posters: remoteData.movie?.data?.posters ?? [],
                                                                                    stills: remoteData.movie?.data?.stills ?? []))
            
            return MyHistoryEntityData(id: remoteData.id ?? "",
                                       numStars: remoteData.numStars ?? "",
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
}
