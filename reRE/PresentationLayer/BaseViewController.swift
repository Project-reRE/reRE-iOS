//
//  BaseViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.gray(.gray10).color
        navigationController?.navigationBar.isHidden = true
        
        addViews()
        makeConstraints()
        setupIfNeeded()
    }
    
    deinit {
        LogDebug("🌈 deinit ---> \(self)")
        deinitialize()
    }
    
    func addViews() {}
    
    func makeConstraints() {}
    
    func setupIfNeeded() {}
    
    func deinitialize() {}
    
    func showToastMessageView(title: String, completion: (() -> Void)? = nil) {
        let toastView = ToastView(title: title)
        view.addSubview(toastView)
        view.bringSubviewToFront(toastView)
        
        toastView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.bottom.equalToSuperview().inset(moderateScale(number: 66) + getSafeAreaBottom())
        }
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
            toastView.alpha = 0
        }, completion: { _ in
            toastView.removeFromSuperview()
            completion?()
        })
    }
}
