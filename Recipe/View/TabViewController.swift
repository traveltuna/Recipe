//
//  TabViewController.swift
//  Recipe
//
//  Created by Fangwei Hsu on 2021/07/17.
//

import UIKit

final class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
}

private extension TabViewController {
    func setupTabBar() {
        let item1 = UINavigationController(rootViewController: RecipeGridViewController.instance())
        let icon1 = UITabBarItem(title: "献立", image: UIImage(named: "menu"), tag: 0)
        item1.tabBarItem = icon1
        let item2 = UINavigationController(rootViewController: FavoriteGridViewController.instance())
        let icon2 = UITabBarItem(title: "お気に入り", image: UIImage(named: "love"), tag: 1)
        item2.tabBarItem = icon2
        let controllers = [item1, item2]
        self.viewControllers = controllers
    }
}
