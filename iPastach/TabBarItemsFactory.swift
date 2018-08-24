//
//  TabBarItemsFactory.swift
//  iPastach
//
//  Created by Юрий Гринев on 24.08.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

enum TabBarItem: Int {
    case pastes, favorites, menu
    
    var viewController: UIViewController {
        switch self {
        case .pastes:
            return PastesViewController()
        case .favorites:
            return PastesViewController()
        case .menu:
            return MenuViewController()
        }
    }
}

class TabBarItemsFactory: NSObject {
    private let items: [TabBarItem]
    
    private static let images: [TabBarItem: UIImage] = [
        .pastes: #imageLiteral(resourceName: "pastes"),
        .favorites: #imageLiteral(resourceName: "favorites"),
        .menu: #imageLiteral(resourceName: "menu")
    ]
    
    private static let titles: [TabBarItem: String] = [
        .pastes: "IPPastes".translated(),
        .favorites: "IPFavorites".translated(),
        .menu: "IPMenu".translated()
    ]
    
    init(items: [TabBarItem]) {
        self.items = items
    }
    
    func makeItems() -> [UIViewController] {
        var result = [UIViewController]()
        for (_, item) in items.enumerated() {
            result.append(createItem(for: item))
        }
        
        return result
    }
    
    private func createItem(for item: TabBarItem) -> UIViewController {
        let viewController = UINavigationController(rootViewController: item.viewController)
        
        viewController.tabBarItem.image = TabBarItemsFactory.images[item]
        
        if UserSettings.shared.showTitlesOnTabbar {
            viewController.tabBarItem.title = TabBarItemsFactory.titles[item]
        } else {
            viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        }

        return viewController
    }
    
}
