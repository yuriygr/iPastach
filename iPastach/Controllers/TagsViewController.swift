//
//  TagsViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController {
    
    //MARK: - Properties
    lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        return table
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .mainBlue
        return refreshControl
    }()
    
    //MARK: - API Stuff
    var api: ApiManager = .shared

    //MARK: - Data
    var tagsList: TagsList = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        fetchDataFromAPI()
    }
    
    //MARK: - Setup view
    func setupController() {
        navigationItem.title = "Теги"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TagCell")
        tableView.addSubview(refreshControl)
        
        view.addSubview(tableView)
    }
    
    //MARK: - Request to API
    fileprivate func fetchDataFromAPI(completion: (() -> ())? = nil) {
        api.tags(TagsList.self, method: .list) { (data, error) in
            if let data = data {
                self.tagsList = data
            }
            if let completion = completion {
                completion()
            }
        }
    }
    
    //MARK: - Actions
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchDataFromAPI() {
            refreshControl.endRefreshing()
        }
    }
}

//MARK: - TableView
extension TagsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !self.tagsList.isEmpty {
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
        return self.tagsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath)
        cell.textLabel?.text = self.tagsList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(
            name: Notification.Name("SelectTag"),
            object: nil,
            userInfo: ["tag": self.tagsList[indexPath.row]]
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
            return 0.01
        }
    }
}
