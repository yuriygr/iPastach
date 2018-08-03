//
//  SettingsViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 21.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()

    //MARK:  Theme
    lazy var theme: Theme = ThemeManager.shared.currentTheme
    lazy var themeManager: ThemeManager = ThemeManager.shared

    //MARK: - Sections
    var sections = [
        "Внешний вид", "Контент"
    ]
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        applyTheme()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyTheme),
            name: .onThemeChanging,
            object: nil
        )
    }
    
    //MARK: - Setup view
    func setupController() {
        navigationItem.title = "IPPreferences".translated()
        extendedLayoutIncludesOpaqueBars = true
    
        tableView.registerCell(UITableViewCell.self, withIdentifier: "yourcellIdentifire")
        view.addSubview(tableView)
    }

    //MARK: - Actions
    
    @objc
    fileprivate func applyTheme() {
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.secondBackgroundColor
        
        self.view.setNeedsLayout()
    }
    
    
    @objc
    func switchChanged(_ sender: UISwitch) {
        themeManager.currentTheme = sender.isOn ? .darkmode : .normal
        NotificationCenter.default.post(
            name: .onThemeChanging,
            object: nil,
            userInfo: ["status": sender.isOn]
        )
    }
}

//MARK: - TableView
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "yourcellIdentifire", for: indexPath) as! UITableViewCell
        
        //here is programatically switch make to the table view
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(theme == .darkmode, animated: true)
        switchView.tag = indexPath.row // for detect which row switch Changed
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        cell.textLabel?.text = "Dark mode"
        cell.textLabel?.textColor = theme.textColor
        cell.backgroundColor = theme.backgroundColor
        cell.customSelectColor(theme.selectColor)
        return cell
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
