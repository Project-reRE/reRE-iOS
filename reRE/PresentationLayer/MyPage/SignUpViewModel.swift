//
//  SignUpViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/10/24.
//

import Foundation
import Combine

final class SignUpViewModel: BaseViewModel {
    private let usecase: LoginUsecaseProtocol
    
    init(usecase: LoginUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        
    }
}
