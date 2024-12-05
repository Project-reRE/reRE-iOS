//
//  MainCoordinator.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit

final class MainCoordinator: MainBaseCoordinator {
    var tabBarCoordinator: TabBarBaseCoordinator = TabBarCoordinator()
    var mainTabBar: UITabBarController?
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let viewModel: SplashViewModel = SplashViewModel(usecase: Injector.shared.resolve(SplashUsecaseProtocol.self)!)
        let splashVC = SplashViewController(viewModel: viewModel)
        splashVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: splashVC)
        rootViewController.hidesBottomBarWhenPushed = true
        
        let navigation = rootViewController as? UINavigationController
        navigation?.isNavigationBarHidden = true
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        guard let flow = appFlow.appFlow else { return }
        
        if mainTabBar == nil {
            tabBarCoordinator.parentCoordinator = self
            mainTabBar = tabBarCoordinator.start() as? UITabBarController
        }
        
        switch flow {
        case .splash:
            startSplashFlow(userData: userData)
        case .tabBar(let tabBarFlow):
            startTabBarFlow(tabBarFlow, userData: userData)
        }
    }
    
    private func startSplashFlow(userData: [String: Any]?) {
        
    }
    
    private func startTabBarFlow(_ tabBarFlow: TabBarFlow, userData: [String: Any]?) {
        guard let mainTabBar = self.mainTabBar else { return }
        
        rootNavigationController?.pushViewController(mainTabBar, animated: true)
        tabBarCoordinator.moveTo(appFlow: tabBarFlow, userData: userData)
    }
}
