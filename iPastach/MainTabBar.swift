//
//  MainTabBar.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {
    
    //TODO: https://stackoverflow.com/questions/30849030/swift-how-to-execute-an-action-when-uitabbaritem-is-pressed/30849225
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pastesViewController = PastesViewController()
        let randomViewController = PasteViewController()
        let favoritesViewController = FavoritesViewController()
        let searchViewController = SearchViewController()
        let setingsViewController = SettingsViewController()
        
        let pastesNavController = UINavigationController(rootViewController: pastesViewController)
        pastesNavController.tabBarItem.image = UIImage(named: "pastes")
        pastesNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
     
        let randomNavController = UINavigationController(rootViewController: randomViewController)
        randomNavController.tabBarItem.image = UIImage(named: "refresh")
        randomNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        let favoritesNavController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavController.tabBarItem.image = UIImage(named: "following")
        favoritesNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        let searchNavController = UINavigationController(rootViewController: searchViewController)
        searchNavController.tabBarItem.image = UIImage(named: "search")
        searchNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        let settingsNavController = UINavigationController(rootViewController: setingsViewController)
        settingsNavController.tabBarItem.image = UIImage(named: "settings")
        settingsNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        // Цвет кнопок
        self.tabBar.unselectedItemTintColor = .mainGrey
        
        setViewControllers([
            pastesNavController, randomNavController, favoritesNavController, searchNavController, settingsNavController
        ], animated: true)
    }
}

