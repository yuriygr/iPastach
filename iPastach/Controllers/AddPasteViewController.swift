//
//  AddPasteViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 02.08.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class AddPasteViewController: UIViewController {
    
    //MARK: - Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()

    //MARK:  Navigation buttons
    lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(handleCancelPressed))
    
    //MARK:  Theme
    lazy var theme: Theme = ThemeManager.shared.currentTheme

    //MARK:  Sections
    var sections = [
        "Название", "История"
    ]

    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    //MARK: - Setup view
    
    fileprivate func setupController() {
        navigationItem.title = "IPAddPaste".translated()
        navigationItem.leftBarButtonItem = cancelButton
        extendedLayoutIncludesOpaqueBars = true
        
        //TODO: Выбор темы
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.secondBackgroundColor
        tableView.separatorColor = theme.backgroundColor
    
        view.addSubview(tableView)
    }
    
    @objc
    func handleCancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - TableView

extension AddPasteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return self.sections[section]
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return tableView.sectionHeaderHeight
        } else {
            if #available(iOS 11.0, *) {
                return 0
            } else {
                return 0.001
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return tableView.sectionFooterHeight
        } else {
            if #available(iOS 11.0, *) {
                return 0
            } else {
                return 0.001
            }
        }
    }
}
