//
//  Publisher+Extension.swift
//  reRE
//
//  Created by 강치훈 on 9/11/24.
//

import Foundation
import Combine

extension Publisher {
    func droppedSink(receiveValue: @escaping ((Output) -> Void)) -> AnyCancellable {
        return self
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: receiveValue)
    }
    
    func mainSink(receiveValue: @escaping ((Output) -> Void)) -> AnyCancellable {
        return self
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: receiveValue)
    }
}
