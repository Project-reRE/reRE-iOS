//
//  HistoryCoordinator.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit

final class HistoryCoordinator: NSObject, HistoryBaseCoordinator {
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    var currentFlowManager: CurrentFlowManager?
    
    func start() -> UIViewController {
        let historyVC = HistoryViewController()
        historyVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: historyVC)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String : Any]?) {
        
    }
}
