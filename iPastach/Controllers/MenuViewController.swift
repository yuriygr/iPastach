//
//  MenuViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 21.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    private var api: APIClient = .shared
    private var theme = UserSettings.shared.currentTheme
    
    //MARK: - Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.registerCell(UITableViewCell.self, withIdentifier: "settingCell")
        tableView.registerCell(UITableViewCell.self, withIdentifier: "informationCell")
        tableView.registerCell(UITableViewCell.self, withIdentifier: "applicationCell")
        tableView.registerCell(SwitchCell.self)
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
        api.fetch([Page].self, method: .pages(.list)) { (data, error) in
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
        super.viewWillAppear(animated)
        setupTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - Setup's

    private func setupController() {
        navigationItem.title = "IPMenu".localized
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
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        api.fetch([Page].self, method: .pages(.list)) { (data, error) in
            DispatchQueue.init(label: "gr.yuriy.iPastach.pages").async {
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    self.pages = data
                }
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

//MARK: - Switch Delegate

extension MenuViewController: SwitchCellDelegate {
    
    func switchChanged(_ sender: UISwitch) {
        if sender.tag == 0 {
            UserSettings.shared.currentTheme = sender.isOn ? .darkmode : .normal
        }
        if sender.tag == 1 {
            UserSettings.shared.showTitlesOnTabbar = sender.isOn
        }
    }
}

//MARK: - TableView Delegate

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
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
            
            switch SettingsSection(rawValue: indexPath.row)! {
            case .theme:
                let cell = tableView.dequeueCell(SwitchCell.self)
                cell.delegate = self
                cell.setTitle("IPDarkmode".localized)
                cell.setTag(indexPath.row)
                cell.setState(theme == .darkmode)
                cell.setupTheme()
                return cell
            case .titles:
                let cell = tableView.dequeueCell(SwitchCell.self)
                cell.delegate = self
                cell.setTitle("IPShowTitlesOnTabBar".localized)
                cell.setTag(indexPath.row)
                cell.setState(UserSettings.shared.showTitlesOnTabbar)
                cell.setupTheme()
                return cell
            case .font:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "settingCell")
                cell.textLabel?.text = "IPFulltextFontsize".localized
                cell.textLabel?.textColor = theme.textColor
                cell.backgroundColor = theme.backgroundColor
                cell.detailTextLabel?.text = String(UserSettings.shared.fontSize)
                cell.accessoryType = .disclosureIndicator
                cell.customSelectColor(theme.selectColor)
                return cell
            }
        }
        if indexPath.section == 1 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "informationCell")
            cell.textLabel?.text = self.pages[indexPath.row].title
            cell.textLabel?.textColor = theme.textColor
            cell.backgroundColor = theme.backgroundColor
            cell.accessoryType = .disclosureIndicator
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
        if indexPath.section == 0 {
            
        }
        if indexPath.section == 1 {
            let pageViewController = PageViewController()
            pageViewController.page = pages[indexPath.row]
            pageViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(pageViewController, animated: true)
        }
    }
    
    // Norm koroche tak sdelat'
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isNotEmptySection(tableView, section) {
            return tableView.sectionHeaderHeight
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.isNotEmptySection(tableView, section) {
            return tableView.sectionFooterHeight
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
