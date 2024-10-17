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
        let viewModel: ProfileViewModel = ProfileViewModel(usecase: Injector.shared.resolve(ProfileUsecaseProtocol.self)!)
        let myPageVC = MyPageViewController(viewModel: viewModel)
        myPageVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: myPageVC)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String : Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .myPage(let myPageFlow):
            startMoreFlow(myPageFlow, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    private func startMoreFlow(_ flow: MyPageFlow, userData: [String: Any]?) {
        switch flow {
        case .appSetting(let appSettingScene):
            startAppsettingFlow(appSettingScene, userData: userData)
        }
    }
    
    private func startAppsettingFlow(_ scene: AppSettingScene, userData: [String: Any]?) {
        switch scene {
        case .main:
            let appSettingVC = AppSettingViewController()
            appSettingVC.coordinator = self
            currentNavigationViewController?.pushViewController(appSettingVC, animated: true)
        case .termsPolicy:
            break
        case .privacyPolicy:
            break
        case .servicePolicy:
            break
        case .teensPolicy:
            break
        case .openAPI:
            break
        case .deleteAccount:
            let viewModel = DeleteAccountViewModel(usecase: Injector.shared.resolve(ProfileUsecaseProtocol.self)!)
            let deleteAccountVC = DeleteAccountViewController(viewModel: viewModel)
            deleteAccountVC.coordinator = self
            currentNavigationViewController?.pushViewController(deleteAccountVC, animated: true)
        }
    }
}
