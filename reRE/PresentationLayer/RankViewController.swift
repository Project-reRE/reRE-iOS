//
//  RankViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit

final class RankViewController: UIViewController {
    var coordinator: RankBaseCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.gray(.gray10).color
    }
}
