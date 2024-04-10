//
//  NetworkManager.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import Foundation
import Moya

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    private func provider(_ token: String? = nil) -> MoyaProvider<NetworkService> {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        
        let session = Session(configuration: configuration)
        
        if let token = token {
            let tokenPlugin = AccessTokenPlugin { _ in token }
            return MoyaProvider<NetworkService>(session: session, plugins: [tokenPlugin])
        } else {
            return MoyaProvider<NetworkService>(session: session)
        }
    }
}

extension NetworkManager {
    func networkMockService(_ completion: @escaping (Result<Response, Error>) -> Void) {
        provider().request(.networkMockService) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
