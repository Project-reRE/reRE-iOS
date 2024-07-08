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
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .common(let commonFlow):
            moveToCommonFlow(commonFlow, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    private func moveToCommonFlow(_ flow: CommonFlow, userData: [String: Any]?) {
        switch flow {
        case .revaluationDetail:
            let viewModel = ReValuationDetailViewModel()
            let revaluationVC = RevaluationDetailViewController(viewModel: viewModel)
            revaluationVC.coordinator = self
            revaluationVC.hidesBottomBarWhenPushed = true
            currentNavigationViewController?.pushViewController(revaluationVC, animated: true)
        case .login:
            let viewModel: LoginViewModel = LoginViewModel(usecase: Injector.shared.resolve(LoginUsecaseProtocol.self)!)
            let loginVC: LoginViewController = LoginViewController(viewModel: viewModel)
            loginVC.coordinator = self
            
            loginVC.modalPresentationStyle = .overFullScreen
            currentNavigationViewController?.present(loginVC, animated: false)
        }
    }
}
