//
//  SplashViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit

final class SplashViewController: UIViewController {
    var coordinator: MainBaseCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.rank), userData: nil)
        }
    }
}
