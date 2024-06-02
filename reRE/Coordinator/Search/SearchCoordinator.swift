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
        let searchVC = SearchMainViewController()
        searchVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: searchVC)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String : Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .search(let searchFlow):
            moveToSearchFlow(searchFlow, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    func moveToSearchFlow(_ flow: SearchFlow, userData: [String: Any]?) {
        switch flow {
        case .main:
            rootNavigationController?.popToRootViewController(animated: true)
        case .search:
            let viewModel = SearchViewModel()
            let searchVC = SearchViewController(viewModel: viewModel)
            searchVC.hidesBottomBarWhenPushed = true
            searchVC.coordinator = self
            currentNavigationViewController?.pushViewController(searchVC, animated: true)
        case .searchDetail:
            break
        }
    }
}
