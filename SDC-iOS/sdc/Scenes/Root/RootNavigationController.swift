//
//  RootNavigationController.swift
//  sdc
//
//  Created by byunghak on 2021/11/04.
//

import UIKit

class RootNavigationController: UINavigationController {
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground        
        let vc = HomeViewController()
        pushVC(viewController: vc, animated: true)
    }
    
    // MARK: - Helper
    func pushVC(viewController: UIViewController, animated: Bool) {
        self.pushViewController(viewController, animated: animated)
    }
}
