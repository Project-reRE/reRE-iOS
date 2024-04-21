//
//  BaseViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit

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
}
