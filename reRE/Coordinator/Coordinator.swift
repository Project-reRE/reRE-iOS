//
//  Coordinator.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var rootViewController: UIViewController { get set }
    
    func start() -> UIViewController
    func moveTo(appFlow: Flow, userData: [String: Any]?)
}

extension Coordinator {
    var rootNavigationController: UINavigationController? {
        (rootViewController as? UINavigationController)
    }
}

protocol Coordinated {
    var coordinator: Coordinator? { get }
}

protocol Flow {}

extension Flow {
    var appFlow: AppFlow? {
        (self as? AppFlow)
    }
    
    var tabBarFlow: TabBarFlow? {
        (self as? TabBarFlow)
    }
}

enum AppFlow: Flow {
    case splash
    case tabBar(TabBarFlow)
}

enum TabBarFlow: Flow {
    case rank
    case search(SearchFlow)
    case history
    case myPage(MyPageFlow)
    case common(CommonFlow)
}

enum SearchFlow: Flow {
    case main
    case search
    case searchDetail
}

enum MyPageFlow: Flow {
    case appSetting(AppSettingScene)
}

enum CommonFlow: Flow {
    case revaluationDetail
}

enum AppSettingScene {
    case main
    case termsPolicy
    case privacyPolicy
    case servicePolicy
    case teensPolicy
    case openSourceLicense
    case openAPI
    case deleteAccount
}
