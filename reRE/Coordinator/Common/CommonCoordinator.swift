//
//  CommonCoordinator.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit

final class CommonCoordinator: NSObject, CommonBaseCoordinator {
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    var currentFlowManager: CurrentFlowManager?
    
    func start() -> UIViewController {
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String : Any]?) {
        
    }
}
