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
        setupNotifications()
        prepareViews()
        delegate = self
    }
    
    func setupNotifications() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(didSendOnPasteAddToFavorite), name: .onPasteAddToFavorite, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSendOnPasteRemoveFromFavorite), name: .onPasteRemoveFromFavorite, object: nil)
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

    //MARK: - Notification handler
    
    @objc
    fileprivate func didSendOnPasteAddToFavorite(notification: Notification) {
        self.tabBar.items?[2].badgeValue = "1"
    }
    
    @objc
    fileprivate func didSendOnPasteRemoveFromFavorite(notification: Notification) {
        self.tabBar.items?[2].badgeValue = nil
    }
}

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            print("random")
        }
    }
}
