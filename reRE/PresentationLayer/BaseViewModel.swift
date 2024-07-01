//
//  BaseViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation
import Combine

class BaseViewModel {
    var cancelBag = Set<AnyCancellable>()
    private let usecase: BaseUsecaseProtocol
    
    init(usecase: BaseUsecaseProtocol) {
        self.usecase = usecase
    }
    
    func getErrorSubject() -> AnyPublisher<Error, Never> {
        return usecase.getErrorSubject()
    }
}
