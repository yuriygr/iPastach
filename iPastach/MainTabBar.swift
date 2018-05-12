//
//  MainTabBar.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let pastesViewController = PastesViewController()
        let tagsViewController = TagsViewController()
        let randomViewController = FavoritesViewController()
        let favoritesViewController = FavoritesViewController()
        let searchViewController = SearchViewController()
        
        let pastesNavController = UINavigationController(rootViewController: pastesViewController)
        pastesNavController.tabBarItem.title = "Пасты"
        pastesNavController.tabBarItem.image = UIImage(named: "pastes")
     
        let tagsNavController = UINavigationController(rootViewController: tagsViewController)
        tagsNavController.tabBarItem.title = "Теги"
        tagsNavController.tabBarItem.image = UIImage(named: "tags")
        
        let randomNavController = UINavigationController(rootViewController: randomViewController)
        randomNavController.tabBarItem.title = "Случайная"
        randomNavController.tabBarItem.image = UIImage(named: "refresh")
        
        let favoritesNavController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavController.tabBarItem.title = "Избранное"
        favoritesNavController.tabBarItem.image = UIImage(named: "following")
        
        let searchNavController = UINavigationController(rootViewController: searchViewController)
        searchNavController.tabBarItem.title = "Поиск"
        searchNavController.tabBarItem.image = UIImage(named: "search")

        setViewControllers([
            pastesNavController, tagsNavController, randomNavController, favoritesNavController, searchNavController
        ], animated: true)
    }
}

