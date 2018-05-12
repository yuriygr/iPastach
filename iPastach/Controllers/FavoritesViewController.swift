//
//  FavoritesViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup view controller
        setupController()
    }
    
    //MARK: - Конфигурация контроллера
    func setupController() {
        navigationItem.title = "Избранное"

        let placeholderView = PlaceholderView(frame: self.view.bounds)
        placeholderView.image = UIImage(named: "following")
        placeholderView.title = "Избранное отсутствует"
        placeholderView.message = "Вы можете добавить пасты в избранное, нажав соответствующую кнопку."

        view.addSubview(placeholderView)
    }
}