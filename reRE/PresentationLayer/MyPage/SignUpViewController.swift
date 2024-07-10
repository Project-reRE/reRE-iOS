//
//  SignUpViewController.swift
//  reRE
//
//  Created by 강치훈 on 7/10/24.
//

import UIKit

final class SignUpViewController: NavigationBaseViewController {
    var coordinator: CommonBaseCoordinator?
    
    private let viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init()
    }
}
