//
//  RankCoordinator.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit

final class RankCoordinator: NSObject, RankBaseCoordinator {
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    var currentFlowManager: CurrentFlowManager?
    
    func start() -> UIViewController {
        let rankVC = RankViewController()
        rankVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: rankVC)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String : Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .rank:
            break
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
}
