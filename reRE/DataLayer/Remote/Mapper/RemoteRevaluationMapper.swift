//
//  RemoteRevaluationMapper.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import Foundation

struct RemoteRevaluationMapper {
    func remoteMovieDetailItemToEntity(remoteItem: RemoteMovieDetailItem) -> MovieDetailEntity {
        let movieDirectorsEntity = remoteItem.data?.directors?.compactMap {
            return MovieDirectorDetailEntity(directorNm: $0.directorNm ?? "",
                                             directorEnNm: $0.directorEnNm ?? "",
                                             directorId: $0.directorId ?? "")
        }
        
        let movieActorsEntity = remoteItem.data?.actors?.compactMap {
            return MovieActorDetailEntity(actorNm: $0.actorNm ?? "",
                                          actorEnNm: $0.actorEnNm ?? "",
                                          actorId: $0.actorId ?? "")
        }
        
        let statistics = remoteItem.statistics?.compactMap { remoteStatisticsItem -> MovieStatisticsEntity in
            let numRecentStars: [MovieRecentRatingsEntity]? = remoteStatisticsItem.numRecentStars?.compactMap {
                return .init(currentDate: $0.currentDate ?? "",
                             numStars: $0.numStars ?? 0)
            }
            
            let numSpecialPointTopThree: [MovieMostSpecialPointEntity]? = remoteStatisticsItem.numSpecialPointTopThree?.compactMap {
                return MovieMostSpecialPointEntity(rank: $0.rank ?? 0,
                                                   type: $0.type ?? "",
                                                   value: $0.value ?? 0)
            }
            
            let numPastValuationPercent: [MovieStatisticsPercentageEntity]? = remoteStatisticsItem.numPastValuationPercent?.compactMap {
                return MovieStatisticsPercentageEntity(rank: $0.rank ?? 0,
                                                       type: $0.type ?? "",
                                                       value: $0.value ?? "")
            }
            
            let numPresentValuationPercent: [MovieStatisticsPercentageEntity]? = remoteStatisticsItem.numPresentValuationPercent?.compactMap {
                return MovieStatisticsPercentageEntity(rank: $0.rank ?? 0,
                                                       type: $0.type ?? "",
                                                       value: $0.value ?? "")
            }
            
            let numGenderPercent: [MovieStatisticsPercentageEntity]? = remoteStatisticsItem.numGenderPercent?.compactMap {
                return MovieStatisticsPercentageEntity(rank: $0.rank ?? 0,
                                                       type: $0.type ?? "",
                                                       value: $0.value ?? "")
            }
            
            let numAgePercent: [MovieStatisticsPercentageEntity]? = remoteStatisticsItem.numAgePercent?.compactMap {
                return MovieStatisticsPercentageEntity(rank: $0.rank ?? 0,
                                                       type: $0.type ?? "",
                                                       value: $0.value ?? "")
            }
            
            return .init(id: remoteStatisticsItem.id ?? "",
                         numRecentStars: numRecentStars ?? [],
                         numStars: remoteStatisticsItem.numStars ?? 0,
                         numStarsParticipants: remoteStatisticsItem.numStarsParticipants ?? 0,
                         numSpecialPoint: .init(PLANNING_INTENT: remoteStatisticsItem.numSpecialPoint?.PLANNING_INTENT ?? 0,
                                                DIRECTORS_DIRECTION: remoteStatisticsItem.numSpecialPoint?.DIRECTORS_DIRECTION ?? 0,
                                                ACTING_SKILLS: remoteStatisticsItem.numSpecialPoint?.ACTING_SKILLS ?? 0,
                                                SCENARIO: remoteStatisticsItem.numSpecialPoint?.SCENARIO ?? 0,
                                                OST: remoteStatisticsItem.numSpecialPoint?.OST ?? 0,
                                                SOCIAL_ISSUES: remoteStatisticsItem.numSpecialPoint?.SOCIAL_ISSUES ?? 0,
                                                VISUAL_ELEMENT: remoteStatisticsItem.numSpecialPoint?.VISUAL_ELEMENT ?? 0,
                                                SOUND_ELEMENT: remoteStatisticsItem.numSpecialPoint?.SOUND_ELEMENT ?? 0),
                         numPastValuation: .init(POSITIVE: remoteStatisticsItem.numPastValuation?.POSITIVE ?? 0,
                                                 NEGATIVE: remoteStatisticsItem.numPastValuation?.NEGATIVE ?? 0,
                                                 NOT_SURE: remoteStatisticsItem.numPastValuation?.NOT_SURE ?? 0),
                         numPresentValuation: .init(POSITIVE: remoteStatisticsItem.numPresentValuation?.POSITIVE ?? 0,
                                                    NEGATIVE: remoteStatisticsItem.numPresentValuation?.NEGATIVE ?? 0,
                                                    NOT_SURE: remoteStatisticsItem.numPresentValuation?.NOT_SURE ?? 0),
                         numGender: .init(MALE: remoteStatisticsItem.numGender?.MALE ?? 0,
                                          FEMALE: remoteStatisticsItem.numGender?.FEMALE ?? 0),
                         numAge: .init(TEENS: remoteStatisticsItem.numAge?.TEENS ?? 0,
                                       TWENTIES: remoteStatisticsItem.numAge?.TWENTIES ?? 0,
                                       THIRTIES: remoteStatisticsItem.numAge?.THIRTIES ?? 0,
                                       FORTIES: remoteStatisticsItem.numAge?.FORTIES ?? 0,
                                       FIFTIES_PLUS: remoteStatisticsItem.numAge?.FIFTIES_PLUS ?? 0),
                         currentDate: remoteStatisticsItem.currentDate ?? "",
                         numSpecialPointTopThree: numSpecialPointTopThree ?? [],
                         numPastValuationPercent: numPastValuationPercent ?? [],
                         numPresentValuationPercent: numPresentValuationPercent ?? [],
                         numGenderPercent: numGenderPercent ?? [],
                         numAgePercent: numAgePercent ?? [])
        }
        
        return .init(id: remoteItem.id ?? "",
                     data: .init(title: remoteItem.data?.title ?? "",
                                 prodYear: remoteItem.data?.prodYear ?? "",
                                 titrepRlsDatele: remoteItem.data?.titrepRlsDatele ?? "",
                                 directors: movieDirectorsEntity ?? [],
                                 actors: movieActorsEntity ?? [],
                                 rating: remoteItem.data?.rating ?? "",
                                 genre: remoteItem.data?.genre ?? "",
                                 posters: remoteItem.data?.posters ?? [],
                                 stills: remoteItem.data?.stills ?? []),
                     statistics: statistics ?? [])
    }
}
