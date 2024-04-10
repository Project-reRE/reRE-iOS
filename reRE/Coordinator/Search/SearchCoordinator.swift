//
//  SearchCoordinator.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit

final class SearchCoordinator: NSObject, SearchBaseCoordinator {
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    var currentFlowManager: CurrentFlowManager?
    
    func start() -> UIViewController {
        let searchVC = SearchViewController()
        searchVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: searchVC)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String : Any]?) {
        
    }
}
