//
//  TagsViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController {

    private var api: APIManager = .shared
    private var theme = UserSettings.shared.currentTheme
    
    //MARK: - Properties

    var canTransitionToLarge = false
    var canTransitionToSmall = true

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        return tableView
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()

    //MARK: - Data

    var tags: [Tag] = []

    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        loadFromAPI() { (data, error) in
            DispatchQueue.main.async {
                self.tableView.reload()
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
    
    //MARK: - Setup view

    fileprivate func setupController() {
        navigationItem.title = "IPTags".translated()
        extendedLayoutIncludesOpaqueBars = true
        
        tableView.registerCell(UITableViewCell.self, withIdentifier: "TagCell")
        view.addSubview(tableView)
    }
    
    fileprivate func setupTheme() {
        view.backgroundColor = theme.backgroundColor
        refreshControl.tintColor = theme.tintColor
        tableView.backgroundColor = theme.backgroundColor
        tableView.separatorColor = theme.separatorColor
    }
    
    //MARK: - Request to API

    fileprivate func loadFromAPI(completion: (([Tag]?, Error?) -> ())? = nil) {
        api.tags([Tag].self, endpoint: .list) { (data, error) in
            if let error = error {
                print(error)
            }
            if let data = data {
                self.tags = data
            }
            if let completion = completion {
                completion(data, error)
            }
        }
    }
    
    //MARK: - Actions
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadFromAPI() { (data, error) in
            DispatchQueue.main.async {
                refreshControl.endRefreshing()
                self.tableView.reload()
            }
        }
    }
}

//MARK: - TableView
extension TagsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !self.tags.isEmpty {
            tableView.backgroundView = nil
            return 1
        } else {
            let tableViewEmptyMessage = TableViewEmptyMessage()
            tableViewEmptyMessage.image = UIImage(named: "tags")
            tableViewEmptyMessage.title = "Список тегов пуст"
            tableViewEmptyMessage.message = "Возможно, вы что-то сделали не так.\nПожалуйста, повторите ещё раз."

            tableView.backgroundView = tableViewEmptyMessage
            tableView.backgroundView?.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withIdentifier: "TagCell")
        cell.textLabel?.text = self.tags[indexPath.row].title
        cell.textLabel?.textColor = theme.textColor
        cell.backgroundColor = theme.backgroundColor
        cell.customSelectColor(theme.selectColor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(
            name: .onSelectTag,
            object: nil,
            userInfo: ["tag": self.tags[indexPath.row]]
        )
        self.navigationController?.popViewController(animated: true)
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
