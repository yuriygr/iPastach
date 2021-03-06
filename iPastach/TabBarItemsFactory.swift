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
        .pastes: "IPPastes".localized,
        .favorites: "IPFavorites".localized,
        .menu: "IPMenu".localized
    ]
    
    init(items: [TabBarItem]) {
        self.items = items
    }
    
    func makeBarItems() -> [UIViewController] {
        var result = [UIViewController]()
        for (_, item) in items.enumerated() {
            result.append(createBarItem(for: item))
        }
        
        return result
    }
    
    private func createBarItem(for item: TabBarItem) -> UIViewController {
        let viewController = UINavigationController(rootViewController: item.viewController)
        
        viewController.tabBarItem.image = TabBarItemsFactory.images[item]
        
        if UserSettings.shared.showTitlesOnTabbar {
            viewController.tabBarItem.title = TabBarItemsFactory.titles[item]
        } else {
            viewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: -6, right: 0)
        }

        return viewController
    }
}
