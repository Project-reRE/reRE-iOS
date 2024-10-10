//
//  DeleteAccountViewModel.swift
//  reRE
//
//  Created by 강치훈 on 8/21/24.
//

import Foundation
import Combine

final class DeleteAccountViewModel: BaseViewModel {
    private let shouldDeleteAccount = PassthroughSubject<Void, Never>()
    private let deleteAccountCompleted = PassthroughSubject<Void, Never>()
    
    private let usecase: ProfileUsecaseProtocol
    
    init(usecase: ProfileUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        shouldDeleteAccount
            .flatMap(usecase.deleteAccount)
            .sink { [weak self] _ in
                self?.deleteAccountCompleted.send(())
            }.store(in: &cancelBag)
    }
    
    func deleteAccount() {
        shouldDeleteAccount.send(())
    }
    
    func getDeleteAccountCompletedPublisher() -> AnyPublisher<Void, Never> {
        return deleteAccountCompleted.eraseToAnyPublisher()
    }
}
