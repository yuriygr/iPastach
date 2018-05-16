//
//  SearchViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view controller
        setupController()
    }
    
    //MARK: - Setup view
    func setupController() {
        navigationItem.title = "Поиск"

        let placeholderView = TableViewEmptyMessage(frame: self.view.bounds)
        placeholderView.image = UIImage(named: "search")
        placeholderView.title = "Поиск не работает"
        placeholderView.message = "Но скоро будет норм."

        view.addSubview(placeholderView)
    }
}
