//
//  TabBarCoordinator.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit

final class TabBarCoordinator: NSObject, TabBarBaseCoordinator {
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UITabBarController()
    var currentFlowManager: CurrentFlowManager?
    
    var rankCoordinator: RankBaseCoordinator = RankCoordinator()
    var searchCoordinator: SearchBaseCoordinator = SearchCoordinator()
    var historyCoordinator: HistoryBaseCoordinator = HistoryCoordinator()
    var myPageCoordinator: MyPageBaseCoordinator = MyPageCoordinator()
    var commonCoordinator: CommonBaseCoordinator = CommonCoordinator()
    
    func start() -> UIViewController {
        let rankVC = rankCoordinator.start()
        rankCoordinator.parentCoordinator = self
        rankVC.tabBarItem = UITabBarItem(title: nil,
                                         image: UIImage(named: "RankTabBarIcon"),
                                         selectedImage: UIImage(named: "RankTabBarIcon")?.withTintColor(ColorSet.primary(.orange90).color!,
                                                                                                        renderingMode: .alwaysOriginal))
        rankVC.tabBarItem.imageInsets = UIEdgeInsets.init(top: moderateScale(number: 5),
                                                          left: 0,
                                                          bottom: -moderateScale(number: 5),
                                                          right: 0)
        let searchVC = searchCoordinator.start()
        searchCoordinator.parentCoordinator = self
        searchVC.tabBarItem = UITabBarItem(title: nil,
                                           image: UIImage(named: "SearchTabBarIcon"),
                                           selectedImage: UIImage(named: "SearchTabBarIcon")?.withTintColor(ColorSet.primary(.orange90).color!,
                                                                                                            renderingMode: .alwaysOriginal))
        searchVC.tabBarItem.imageInsets = UIEdgeInsets.init(top: moderateScale(number: 5),
                                                            left: 0,
                                                            bottom: -moderateScale(number: 5),
                                                            right: 0)
        
        let historyVC = historyCoordinator.start()
        historyCoordinator.parentCoordinator = self
        historyVC.tabBarItem = UITabBarItem(title: nil,
                                            image: UIImage(named: "HistoryTabBarIcon"),
                                            selectedImage: UIImage(named: "HistoryTabBarIcon")?.withTintColor(ColorSet.primary(.orange90).color!,
                                                                                                              renderingMode: .alwaysOriginal))
        historyVC.tabBarItem.imageInsets = UIEdgeInsets.init(top: moderateScale(number: 5),
                                                             left: 0,
                                                             bottom: -moderateScale(number: 5),
                                                             right: 0)
        
        let myPageVC = myPageCoordinator.start()
        myPageCoordinator.parentCoordinator = self
        myPageVC.tabBarItem = UITabBarItem(title: nil,
                                           image: UIImage(named: "MyPageTabBarIcon"),
                                           selectedImage: UIImage(named: "MyPageTabBarIcon")?.withTintColor(ColorSet.primary(.orange90).color!,
                                                                                                            renderingMode: .alwaysOriginal))
        myPageVC.tabBarItem.imageInsets = UIEdgeInsets.init(top: moderateScale(number: 5),
                                                            left: 0,
                                                            bottom: -moderateScale(number: 5),
                                                            right: 0)
        
        let customTabBar = BaseTabBar()
        
        let rootTabBar = rootViewController as? UITabBarController
        rootTabBar?.setValue(customTabBar, forKey: "tabBar")
        rootTabBar?.delegate = self
        rootTabBar?.viewControllers = [rankVC, searchVC, historyVC, myPageVC]
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundImage = UIImage()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.stackedItemPositioning = .centered
        
        let tabBarWidth: CGFloat = UIScreen.main.bounds.width - moderateScale(number: 32)
        appearance.stackedItemWidth = tabBarWidth / 4
        appearance.stackedItemSpacing = 1
        
        UITabBar.appearance().standardAppearance = appearance
        
        rootTabBar?.tabBar.standardAppearance = appearance
        rootTabBar?.tabBar.scrollEdgeAppearance = appearance
        
        currentFlowManager = CurrentFlowManager()
        currentFlowManager?.currentCoordinator = rankCoordinator
        
        rankCoordinator.currentFlowManager = currentFlowManager
        searchCoordinator.currentFlowManager = currentFlowManager
        historyCoordinator.currentFlowManager = currentFlowManager
        myPageCoordinator.currentFlowManager = currentFlowManager
        
        commonCoordinator.parentCoordinator = self
        commonCoordinator.currentFlowManager = currentFlowManager
        
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String : Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .rank:
            startRankFlow(tabBarFlow, userData: userData)
        case .search:
            startSearchFlow(tabBarFlow, userData: userData)
        case .history:
            startHistoryFlow(tabBarFlow, userData: userData)
        case .myPage:
            startMyPageFlow(tabBarFlow, userData: userData)
        case .common:
            startCommonFlow(tabBarFlow, userData: userData)
        }
    }
    
    private func startRankFlow(_ flow: Flow, userData: [String: Any]?) {
        currentFlowManager?.currentCoordinator = rankCoordinator
        (rootViewController as? UITabBarController)?.selectedIndex = TabType.rank.rawValue
        rankCoordinator.moveTo(appFlow: flow, userData: userData)
    }
    
    private func startSearchFlow(_ flow: Flow, userData: [String: Any]?) {
        currentFlowManager?.currentCoordinator = searchCoordinator
        (rootViewController as? UITabBarController)?.selectedIndex = TabType.search.rawValue
        searchCoordinator.moveTo(appFlow: flow, userData: userData)
    }
    
    private func startHistoryFlow(_ flow: Flow, userData: [String: Any]?) {
        currentFlowManager?.currentCoordinator = historyCoordinator
        (rootViewController as? UITabBarController)?.selectedIndex = TabType.history.rawValue
        historyCoordinator.moveTo(appFlow: flow, userData: userData)
    }
    
    private func startMyPageFlow(_ flow: Flow, userData: [String: Any]?) {
        currentFlowManager?.currentCoordinator = myPageCoordinator
        (rootViewController as? UITabBarController)?.selectedIndex = TabType.myPage.rawValue
        myPageCoordinator.moveTo(appFlow: flow, userData: userData)
    }
    
    private func startCommonFlow(_ flow: Flow, userData: [String: Any]?) {
        commonCoordinator.moveTo(appFlow: flow, userData: userData)
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if currentFlowManager?.currentCoordinator?.rootNavigationController == viewController,
           let rootViewController = (viewController as? UINavigationController)?.viewControllers.first,
           let tabBarChildViewController = rootViewController as? TabBarChildBaseCoordinated {
            tabBarChildViewController.moveToTopContent()
        }
        
        guard let tabType = TabType(rawValue: tabBarController.selectedIndex) else { return }
        
        switch tabType {
        case .rank:
            currentFlowManager?.currentCoordinator = rankCoordinator
        case .search:
            currentFlowManager?.currentCoordinator = searchCoordinator
        case .history:
            currentFlowManager?.currentCoordinator = historyCoordinator
        case .myPage:
            currentFlowManager?.currentCoordinator = myPageCoordinator
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController),
              let tabType = TabType(rawValue: selectedIndex) else {
            return false
        }
        
        return true
    }
}
