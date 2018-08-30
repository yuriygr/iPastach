//
//  MenuViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 21.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    private var api: APIManager = .shared
    private var theme = UserSettings.shared.currentTheme
    
    //MARK: - Properties

    var canTransitionToLarge = false
    var canTransitionToSmall = true
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.registerCell(UITableViewCell.self, withIdentifier: "settingCell")
        tableView.registerCell(UITableViewCell.self, withIdentifier: "informationCell")
        tableView.registerCell(UITableViewCell.self, withIdentifier: "applicationCell")
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()

    //MARK: - Data

    var sections: [TableSection] = [
        TableSection(header: "Внешний вид", content: nil, footer: "Требуется перезагрузка приложения"),
        TableSection(header: "Помощь", content: nil, footer: "По любым другим вопросам обращаться на info@pastach.ru"),
        TableSection(header: "Приложение", content: nil, footer: nil)
    ]
    var pages = [Page]()
    var application: [String] = [
        "IPVersion".localized + ": " + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String),
        UIDevice.modelName
    ]
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        api.fetch([Page].self, method: .pastes(.list)) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                self.pages = data
            }
            DispatchQueue.main.async {
                self.tableView.reload(section: 1, with: .none)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - Setup's

    private func setupController() {
        navigationItem.title = "IPMenu".localized
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        navigationItem.withoutTitleOnBackBarButton = true
        extendedLayoutIncludesOpaqueBars = true
        view.addSubview(tableView)
    }
    
    private func setupTheme() {
        view.backgroundColor = theme.secondBackgroundColor
        tableView.backgroundColor = theme.secondBackgroundColor
        tableView.separatorColor = theme.separatorColor
        refreshControl.tintColor = theme.secondTextColor
    }
    
    @objc
    func switchChanged(_ sender: UISwitch) {
        if sender.tag == 0 {
            UserSettings.shared.currentTheme = sender.isOn ? .darkmode : .normal
        }
        if sender.tag == 1 {
            UserSettings.shared.showTitlesOnTabbar = sender.isOn
        }
    }

    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        api.fetch([Page].self, method: .pages(.list)) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                self.pages = data
            }
            DispatchQueue.main.async {
                refreshControl.endRefreshing()
                self.tableView.reload(section: 1, with: .none)
            }
        }
    }
}

//MARK: - ScrollView Delegate

extension MenuViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}

//MARK: - TableView Delegate

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    func isNotEmptySection(_ tableView: UITableView, _ section: Int) -> Bool {
        return self.tableView(tableView, numberOfRowsInSection: section) > 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        if section == 1 {
            return self.pages.count
        }
        if section == 2 {
            return self.application.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return self.sections[section].header
        }
        return nil
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return self.sections[section].footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "settingCell")
        
            if indexPath.row == 0 {
                let switchView = UISwitch(frame: .zero)
                switchView.tag = indexPath.row
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                switchView.setOn(theme == .darkmode, animated: false)
                cell.accessoryView = switchView
                cell.textLabel?.text = "Dark mode".localized
            }
            if indexPath.row == 1 {
                let switchView = UISwitch(frame: .zero)
                switchView.tag = indexPath.row
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                switchView.setOn(UserSettings.shared.showTitlesOnTabbar, animated: false)
                cell.accessoryView = switchView
                cell.textLabel?.text = "Show titles on tabbar".localized
            }
            if indexPath.row == 2 {
                cell.accessoryView = nil
                cell.textLabel?.text = "Размер шрифта".localized
            }
            cell.textLabel?.textColor = theme.textColor
            cell.backgroundColor = theme.backgroundColor
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.section == 1 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "informationCell")
            cell.textLabel?.text = self.pages[indexPath.row].title
            cell.textLabel?.textColor = theme.textColor
            cell.backgroundColor = theme.backgroundColor
            cell.customSelectColor(theme.selectColor)
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "applicationCell")
            cell.textLabel?.text = self.application[indexPath.row]
            cell.textLabel?.textColor = theme.secondTextColor
            cell.backgroundColor = theme.backgroundColor
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.section == 1 {
            let pageViewController = PageViewController()
            pageViewController.page = pages[indexPath.row]
            pageViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(pageViewController, animated: true)
        }
    }
    
    // Norm koroche tak sdelat'
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isNotEmptySection(tableView, section) {
            return tableView.sectionHeaderHeight
        } else {
            if #available(iOS 11.0, *) {
                return 0.0
            } else {
                return 0.001
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.isNotEmptySection(tableView, section) {
            return tableView.sectionFooterHeight
        } else {
            if #available(iOS 11.0, *) {
                return 0.0
            } else {
                return 0.001
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
