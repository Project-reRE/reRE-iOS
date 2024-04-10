//
//  MyPageCoordinator.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit

final class MyPageCoordinator: NSObject, MyPageBaseCoordinator {
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    var currentFlowManager: CurrentFlowManager?
    
    func start() -> UIViewController {
        let myPageVC = MyPageViewController()
        myPageVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: myPageVC)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String : Any]?) {
        
    }
}
