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
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .history(let historyFlow):
            moveToHistoryFlow(historyFlow, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    private func moveToHistoryFlow(_ flow: HistoryFlow, userData: [String: Any]?) {
        switch flow {
        case .main:
            let viewModel: HistoryListViewModel = HistoryListViewModel(usecase: Injector.shared.resolve(HistoryUsecaseProtocol.self)!)
            let historyListVC = HistoryListViewController(viewModel: viewModel)
            historyListVC.coordinator = self
            historyListVC.hidesBottomBarWhenPushed = true
            currentNavigationViewController?.pushViewController(historyListVC, animated: true)
        }
    }
}
