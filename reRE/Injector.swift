//
//  Injector.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation
import Swinject

struct Injector {
    private init() {}
    
    static let shared: Container = {
        let container = Container()
        
        // MARK: - DataFetchable
        container.register(RemoteDataFetchable.self) { _ in
            return RemoteDataFetcher()
        }
        
        container.register(LocalDataFetchable.self) { _ in
            return LocalDataFetcher()
        }
        
        // MARK: - repository
        container.register(SplashRepositoryProtocol.self) { resolver in
            let repository = SplashRepository(localDataFetcher: resolver.resolve(LocalDataFetchable.self)!,
                                              remoteDataFetcher: resolver.resolve(RemoteDataFetchable.self)!)
            return repository
        }
        
        container.register(RankRepositoryProtocol.self) { resolver in
            let repository = RankRepository(remoteDataFetcher: resolver.resolve(RemoteDataFetchable.self)!)
            return repository
        }
        
        container.register(LoginRepositoryProtocol.self) { resolver in
            let repository = LoginRepository(remoteDataFetcher: resolver.resolve(RemoteDataFetchable.self)!)
            return repository
        }
        
        // MARK: - usecase
        container.register(SplashUsecaseProtocol.self) { resolver in
            let usecase = SplashUsecase(repository: resolver.resolve(SplashRepositoryProtocol.self)!)
            return usecase
        }
        
        container.register(RankUsecaseProtocol.self) { resolver in
            let usecase = RankUsecase(repository: resolver.resolve(RankRepositoryProtocol.self)!)
            return usecase
        }
        
        container.register(LoginUsecaseProtocol.self) { resolver in
            let usecase = LoginUsecase(repository: resolver.resolve(LoginRepositoryProtocol.self)!)
            return usecase
        }
        
        return container
    }()
}
