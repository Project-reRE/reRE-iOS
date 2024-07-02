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
    
    func remoteMovieSetsItemToEntity(remoteItem: RemoteMovieSetsItem) -> [MovieSetsEntity] {
        guard let movieSets = remoteItem.results else { return [] }
        
        return movieSets.map { remoteMovieSetsItem -> MovieSetsEntity in
            guard let data = remoteMovieSetsItem.data else { return .init(title: "", template: "", displayOrder: 0, condition: "", data: []) }
            
            let movieSetEntity: [MovieSetEntity] = data.map { remoteMovieSetItem -> MovieSetEntity in
                let directorsEntity: MovieDirectorEntity = remoteMovieDirectorDataToEntity(remoteData: remoteMovieSetItem.directors)
                let actorsEntity: MovieActorEntity = remoteMovieActorDataToEntity(remoteData: remoteMovieSetItem.actors)
                
                return MovieSetEntity(DOCID: remoteMovieSetItem.DOCID ?? "",
                                      movieId: remoteMovieSetItem.movieId ?? "",
                                      movieSeq: remoteMovieSetItem.movieSeq ?? "",
                                      title: remoteMovieSetItem.title ?? "",
                                      prodYear: remoteMovieSetItem.prodYear ?? "",
                                      directors: directorsEntity,
                                      actors: actorsEntity,
                                      nation: remoteMovieSetItem.nation ?? "",
                                      company: remoteMovieSetItem.company ?? "",
                                      runtime: remoteMovieSetItem.runtime ?? "",
                                      rating: remoteMovieSetItem.rating ?? "",
                                      genre: remoteMovieSetItem.genre ?? "",
                                      repRatDate: remoteMovieSetItem.repRatDate ?? "",
                                      repRlsDate: remoteMovieSetItem.repRlsDate ?? "",
                                      posters: remoteMovieSetItem.posters ?? "",
                                      stlls: remoteMovieSetItem.stlls ?? "")
            }
            
            return MovieSetsEntity(title: remoteMovieSetsItem.title ?? "",
                                   template: remoteMovieSetsItem.template ?? "",
                                   displayOrder: remoteMovieSetsItem.displayOrder ?? 0,
                                   condition: remoteMovieSetsItem.condition ?? "",
                                   data: movieSetEntity)
        }
    }
    
    private func remoteMovieDirectorDataToEntity(remoteData: RemoteMovieDirectorData?) -> MovieDirectorEntity {
        guard let directorDetailData = remoteData?.director else { return .init(director: []) }
        
        let director: [MovieDirectorDetailEntity] = directorDetailData.map { remoteItem -> MovieDirectorDetailEntity in
            return remoteMovieDirectorDetailDataToEntity(remoteData: remoteItem)
        }
        
        return MovieDirectorEntity(director: director)
    }
    
    private func remoteMovieDirectorDetailDataToEntity(remoteData: RemoteMovieDirectorDetailData) -> MovieDirectorDetailEntity {
        return MovieDirectorDetailEntity(directorNm: remoteData.directorNm ?? "",
                                         directorEnNm: remoteData.directorEnNm ?? "",
                                         directorId: remoteData.directorId ?? "")
    }
    
    private func remoteMovieActorDataToEntity(remoteData: RemoteMovieActorData?) -> MovieActorEntity {
        guard let actorDetailData = remoteData?.actor else { return .init(actor: []) }
        
        let actor: [MovieActorDetailEntity] = actorDetailData.map { remoteItem -> MovieActorDetailEntity in
            return remoteMovieActorDetailDataToEntity(remoteData: remoteItem)
        }
        
        return MovieActorEntity(actor: actor)
    }
    
    private func remoteMovieActorDetailDataToEntity(remoteData: RemoteMovieActorDetailData) -> MovieActorDetailEntity {
        return MovieActorDetailEntity(actorNm: remoteData.actorNm ?? "",
                                      actorEnNm: remoteData.actorEnNm ?? "",
                                      actorId: remoteData.actorId ?? "")
    }
}
