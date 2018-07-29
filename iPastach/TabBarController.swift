//
//  TabBarController.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        delegate = self
    }
    
    fileprivate func prepareViews() {
        var viewsArray: [UIViewController] = []
        viewsArray.append(setupView(for: PastesViewController(), image: "pastes"))
        viewsArray.append(setupView(for: PasteViewController(), image: "refresh"))
        viewsArray.append(setupView(for: FavoritesViewController(), image: "following"))
        viewsArray.append(setupView(for: SearchViewController(), image: "search"))
        viewsArray.append(setupView(for: SettingsViewController(), image: "settings"))
        
        setViewControllers(viewsArray, animated: true) 
    }
    
    fileprivate func setupView(for vc: UIViewController, image: String?) -> UIViewController {
        let viewController = UINavigationController(rootViewController: vc)
        
        if let image = image {
            viewController.tabBarItem.image = UIImage(named: image)
        }

        viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        return viewController
    }
}

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            print("random")
        }
    }
}
