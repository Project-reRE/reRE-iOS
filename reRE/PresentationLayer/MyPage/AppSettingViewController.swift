//
//  AppSettingViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/05/15.
//

import UIKit

final class AppSettingViewController: UIViewController {
    var coordinator: MyPageBaseCoordinator?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
    }
}
