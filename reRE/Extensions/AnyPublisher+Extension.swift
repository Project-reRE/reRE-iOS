//
//  AnyPublisher+Extension.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation
import Combine

extension AnyPublisher {
    func droppedSink(receiveValue: @escaping ((Output) -> Void)) -> AnyCancellable {
        return self
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: receiveValue)
    }
}
