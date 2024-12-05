//
//  MainBaseCoordinator.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit

protocol MainBaseCoordinator: Coordinator {
    var tabBarCoordinator: TabBarBaseCoordinator { get }
    var mainTabBar: UITabBarController? { get }
}
