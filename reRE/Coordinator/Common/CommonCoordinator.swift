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
        case .web:
            let webViewType = userData?["webViewType"] as? WebViewType
            let url = userData?["url"] as? URL
            
            let webVC = BaseWebViewController(webViewType: webViewType, url: url)
            webVC.coordinator = self
            currentNavigationViewController?.pushViewController(webVC, animated: true)
        case .revaluationDetail:
            guard let movieId = userData?["movieId"] as? String else { return }
            
            let viewModel = ReValuationDetailViewModel(usecase: Injector.shared.resolve(RevaluationUsecaseProtocol.self)!,
                                                       movieId: movieId)
            let revaluationVC = RevaluationDetailViewController(viewModel: viewModel)
            revaluationVC.coordinator = self
            revaluationVC.hidesBottomBarWhenPushed = true
            currentNavigationViewController?.pushViewController(revaluationVC, animated: true)
        case .login:
            let viewModel: LoginViewModel = LoginViewModel(usecase: Injector.shared.resolve(LoginUsecaseProtocol.self)!)
            let loginVC: LoginViewController = LoginViewController(viewModel: viewModel)
            loginVC.coordinator = self
            
            currentNavigationViewController?.pushViewController(loginVC, animated: true)
        case .signUp:
            guard let viewModel = userData?["viewModel"] as? LoginViewModel else { return }
            
            let signUpVC = SignUpViewController(viewModel: viewModel)
            signUpVC.coordinator = self
            
            signUpVC.hidesBottomBarWhenPushed = true
            currentNavigationViewController?.pushViewController(signUpVC, animated: true)
        case .revaluate:
            guard let movieEntity = userData?["movieEntity"] as? MovieDetailEntity else { return }
            
            let myHistoryEntity: MyHistoryEntityData? = userData?["myHistoryEntity"] as? MyHistoryEntityData
            let viewModel: RevaluateViewModel = RevaluateViewModel(usecase: Injector.shared.resolve(RevaluationUsecaseProtocol.self)!,
                                                                   movieEntity: movieEntity,
                                                                   myHistoryEntity: myHistoryEntity)
            let revaluateVC = RevaluateViewController(viewModel: viewModel)
            revaluateVC.coordinator = self
            
            revaluateVC.hidesBottomBarWhenPushed = true
            currentNavigationViewController?.pushViewController(revaluateVC, animated: true)
        case .otherRevaluations:
            guard let movieId = userData?["movieId"] as? String else { return }
            
            let viewModel = OtherRevaluationsViewModel(usecase: Injector.shared.resolve(RevaluationUsecaseProtocol.self)!,
                                                       movieId: movieId)
            let otherRevaluationsVC = OtherRevaluationsViewController(viewModel: viewModel)
            otherRevaluationsVC.coordinator = self
            currentNavigationViewController?.pushViewController(otherRevaluationsVC, animated: true)
        case .search:
            let viewModel = SearchViewModel(usecase: Injector.shared.resolve(SearchUsecaseProtocol.self)!)
            let searchVC = SearchViewController(viewModel: viewModel)
            searchVC.hidesBottomBarWhenPushed = true
            searchVC.coordinator = self
            currentNavigationViewController?.pushViewController(searchVC, animated: true)
        }
    }
}
