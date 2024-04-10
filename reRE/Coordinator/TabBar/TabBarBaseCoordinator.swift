//
//  TabBarBaseCoordinator.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit

final class CurrentFlowManager {
    var currentCoordinator: Coordinator?
}

protocol CurrentCoordinated {
    var currentFlowManager: CurrentFlowManager? { get set }
}

extension CurrentCoordinated {
    var currentNavigationViewController: UINavigationController? {
        get {
            (currentFlowManager?.currentCoordinator?.rootViewController as? UINavigationController)
        }
    }
}

protocol TabBarBaseCoordinator: Coordinator, CurrentCoordinated {
    var rankCoordinator: RankBaseCoordinator { get }
    var searchCoordinator: SearchBaseCoordinator { get }
    var historyCoordinator: HistoryBaseCoordinator { get }
    var myPageCoordinator: MyPageBaseCoordinator { get }
    var commonCoordinator: CommonBaseCoordinator { get }
}

protocol TabBarChildBaseCoordinated {
    func moveToTopContent()
}
