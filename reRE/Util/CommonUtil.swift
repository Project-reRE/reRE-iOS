//
//  CommonUtil.swift
//  reRE
//
//  Created by 강치훈 on 7/28/24.
//

import UIKit

final class CommonUtil {
    static let shared = CommonUtil()
    
    private init() {}
    
    private enum AppStore: String {
        case appStore = ""
    }
    
    static var appVersion: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
    static func goToAppStore() {
        guard let url = URL(string: AppStore.appStore.rawValue), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.last { $0.isKeyWindow }
        var topVC = keyWindow?.rootViewController
        
        while true {
            if let presented = topVC?.presentedViewController {
                topVC = presented
            } else if let navigationController = topVC as? UINavigationController {
                topVC = navigationController.visibleViewController
            } else if let tabBarController = topVC as? UITabBarController {
                topVC = tabBarController.selectedViewController
            } else {
                break
            }
        }
        
        return topVC
    }
    
    static func showAlertView(withType type: AlertType,
                              buttonType: AlertButtonType,
                              title: String?,
                              description: String?,
                              delegate: AlertViewControllerDelegate? = nil,
                              submitText: String? = nil,
                              cancelText: String? = nil,
                              submitCompletion: (() -> Void)?,
                              cancelCompletion: (() -> Void)?) {
        guard let topVC = topViewController() else { return }
        guard !(topVC is AlertViewController) else { return }
        
        hideLoadingView()
        
        let alertVC = AlertViewController(alertButtonType: buttonType, alertType: type)
        alertVC.configureAlertView(withTitle: title,
                                   description: description,
                                   delegate: delegate,
                                   submitText: submitText,
                                   cancelText: cancelText,
                                   submitCompletion: submitCompletion,
                                   cancelCompletion: cancelCompletion)
        
        alertVC.modalPresentationStyle = .overFullScreen
        topVC.present(alertVC, animated: false)
    }
    
    static func hideAlertView(_ completion: (() -> Void)? = nil) {
        guard let topVC = CommonUtil.topViewController(),
              let alertVC = topVC as? AlertViewController else {
            return
            
        }
        
        alertVC.dismiss(animated: false, completion: completion)
    }
    
    static func showLoadingView() {
//        guard UIApplication.shared.windows.last?.subviews.contains(where: { $0 is LoadingView }) == false else { return }
//        
//        let loadingView = LoadingView()
//        loadingView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
//        UIApplication.shared.windows.last?.addSubview(loadingView)
    }
    
    static func hideLoadingView() {
//        if let loadingView = UIApplication.shared.windows.last?.subviews.first(where: { $0 is LoadingView }) {
//            loadingView.removeFromSuperview()
//        } else if let loadingView = UIApplication.shared.windows.first?.subviews.first(where: { $0 is LoadingView }) {
//            loadingView.removeFromSuperview()
//        } else if let topVC = CommonUtil.topViewController(), let loadingView = topVC.view.subviews.first(where: { $0 is LoadingView }) {
//            loadingView.removeFromSuperview()
//        }
    }
}
