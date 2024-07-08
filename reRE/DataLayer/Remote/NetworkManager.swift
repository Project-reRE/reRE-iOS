//
//  NetworkManager.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import Foundation
import Alamofire
import Moya

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    private func provider(_ token: String? = nil, customHeader: HTTPHeaders? = nil) -> MoyaProvider<NetworkService> {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        
        if let customHeader = customHeader {
            customHeader.forEach {
                configuration.headers.add($0)
            }
        }
        
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
    func fetchPublicService(_ service: NetworkService, _ completion: @escaping (Result<Response, Error>) -> Void) {
        provider().request(service) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchService(withHeader token: String, _ service: NetworkService, _ completion: @escaping (Result<Response, Error>) -> Void) {
        provider(nil, customHeader: HTTPHeaders([HTTPHeader(name: "kakao-token", value: token)]))
            .request(service) { result in
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
