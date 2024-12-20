//
//  RemoteBannerMapper.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation

struct RemoteBannerMapper {
    func remoteVersionItemToEntity(remoteItem: RemoteVersionItem) -> VersionEntity {
        return .init(platform: remoteItem.platform ?? "",
                     stableVersion: remoteItem.stableVersion ?? "",
                     minimumVersion: remoteItem.minimumVersion ?? "")
    }
    
    func remoteBannerItemToEntity(remoteItem: RemoteBannerItem) -> [BannerEntity] {
        guard let bannerList = remoteItem.results else { return [] }
        return bannerList.map { remoteItem -> BannerEntity in
            return BannerEntity(displayOrder: remoteItem.displayOrder ?? 0,
                                imageUrl: remoteItem.imageUrl ?? "",
                                route: remoteItem.route ?? "")
        }
    }
    
    func remoteMovieSetsItemToEntity(remoteItem: [RemoteMovieSetsItem]) -> [MovieSetsEntity] {
        return remoteItem.map { remoteMovieSetsItem -> MovieSetsEntity in
            guard let remoteMovieSetsData = remoteMovieSetsItem.data else { return .init() }
            
            let movieSetEntities = remoteMovieSetsData.map { remoteMovieSetData -> MovieSetEntity in
                let actorsEntity = remoteMovieActorDataToEntity(remoteData: remoteMovieSetData.data?.actors)
                let directorsEntity = remoteMovieDirectorDataToEntity(remoteData: remoteMovieSetData.data?.directors)
                return MovieSetEntity(id: remoteMovieSetData.id ?? "", data: .init(title: remoteMovieSetData.data?.title ?? "",
                                                                                   genre: remoteMovieSetData.data?.genre ?? [],
                                                                                   repRlsDate: remoteMovieSetData.data?.repRlsDate ?? "",
                                                                                   directors: directorsEntity,
                                                                                   actors: actorsEntity,
                                                                                   posters: remoteMovieSetData.data?.posters ?? [],
                                                                                   stills: remoteMovieSetData.data?.stills ?? []))
            }
            
            return MovieSetsEntity(title: remoteMovieSetsItem.title ?? "",
                                   genre: remoteMovieSetsItem.genre ?? "",
                                   template: remoteMovieSetsItem.template ?? "",
                                   displayOrder: remoteMovieSetsItem.displayOrder ?? 0,
                                   condition: remoteMovieSetsItem.condition ?? "",
                                   data: movieSetEntities)
        }
    }
    
    private func remoteMovieDirectorDataToEntity(remoteData: [RemoteMovieDirectorDetailData]?) -> [MovieDirectorDetailEntity] {
        guard let remoteData = remoteData else { return [] }
        
        return remoteData.compactMap { remoteItem -> MovieDirectorDetailEntity in
            return .init(directorNm: remoteItem.directorNm ?? "",
                         directorEnNm: remoteItem.directorEnNm ?? "",
                         directorId: remoteItem.directorId ?? "")
        }
    }
    
    private func remoteMovieActorDataToEntity(remoteData: [RemoteMovieActorDetailData]?) -> [MovieActorDetailEntity] {
        guard let remoteData = remoteData else { return [] }
        
        return remoteData.compactMap { remoteItem -> MovieActorDetailEntity in
            return .init(actorNm: remoteItem.actorNm ?? "",
                         actorEnNm: remoteItem.actorEnNm ?? "",
                         actorId: remoteItem.actorId ?? "")
        }
    }
}
