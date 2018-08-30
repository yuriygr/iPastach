//
//  TabBarController.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let tabBarItemsFactory = TabBarItemsFactory(items: [
        .pastes, .favorites, .menu
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        let items = tabBarItemsFactory.makeItems()
        setViewControllers(items, animated: false)
    }
}
