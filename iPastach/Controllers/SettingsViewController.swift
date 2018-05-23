//
//  SettingsViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 21.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view controller
        setupController()
    }
    
    //MARK: - Setup view
    func setupController() {
        navigationItem.title = "Настройки"

        let placeholderView = TableViewEmptyMessage(frame: self.view.bounds)
        placeholderView.image = UIImage(named: "settings")
        placeholderView.title = "Настройки не работают"
        placeholderView.message = "Но скоро будет норм."

        view.addSubview(placeholderView)
    }
}
