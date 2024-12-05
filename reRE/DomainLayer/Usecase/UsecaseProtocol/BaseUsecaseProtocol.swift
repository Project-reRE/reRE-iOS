//
//  BaseUsecaseProtocol.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation
import Combine

protocol BaseUsecaseProtocol: AnyObject {
    func getErrorSubject() -> AnyPublisher<Error, Never>
}
