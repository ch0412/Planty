//
//  TabBarController.swift
//  Planty
//
//  Created by choeun on 5/30/26.
//

import UIKit

// 탭 바 컨트롤러 - 탭 전환 시 네비게이션 스택 초기화 처리
class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let nav = viewController as? UINavigationController {
            nav.popToRootViewController(animated: false)
        }
    }
}
