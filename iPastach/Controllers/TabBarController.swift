//
//  TabBarController.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    private var theme = UserSettings.shared.currentTheme
    
    //MARK: - Properties
    
    private let tabBarItemsFactory = TabBarItemsFactory(items: [
        .pastes, .favorites, .menu
    ])
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - Setup's
    
    private func setupController() {
        let items = tabBarItemsFactory.makeBarItems()
        setViewControllers(items, animated: false)
    }

    private func setupTheme() {
        tabBar.barStyle = theme.barStyle
        tabBar.barTintColor = theme.backgroundColor
        tabBar.tintColor = theme.tintColor
    }
}
