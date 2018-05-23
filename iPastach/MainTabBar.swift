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
        let randomViewController = PasteViewController()
        let favoritesViewController = FavoritesViewController()
        let searchViewController = SearchViewController()
        let setingsViewController = SettingsViewController()
        
        let pastesNavController = UINavigationController(rootViewController: pastesViewController)
        pastesNavController.tabBarItem.title = "Пасты"
        pastesNavController.tabBarItem.image = UIImage(named: "pastes")
     
        let randomNavController = UINavigationController(rootViewController: randomViewController)
        randomNavController.tabBarItem.title = "Случайная"
        randomNavController.tabBarItem.image = UIImage(named: "refresh")
        
        let favoritesNavController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavController.tabBarItem.title = "Избранное"
        favoritesNavController.tabBarItem.image = UIImage(named: "following")
        
        let searchNavController = UINavigationController(rootViewController: searchViewController)
        searchNavController.tabBarItem.title = "Поиск"
        searchNavController.tabBarItem.image = UIImage(named: "search")
        
        let settingsNavController = UINavigationController(rootViewController: setingsViewController)
        settingsNavController.tabBarItem.title = "Настройки"
        settingsNavController.tabBarItem.image = UIImage(named: "settings")
        
        setViewControllers([
            pastesNavController, randomNavController, favoritesNavController, searchNavController, settingsNavController
        ], animated: true)
    }
}

