//
//  PastesViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class PastesViewController: UIViewController {
    
    //MARK: - Properties
    lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return table
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .mainBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Обновляем пасты...")
        return refreshControl
    }()
    
    //MARK: - API Stuff
    var api: ApiManager = .shared
    var apiParams = [String:String]()
    
    //MARK: - Data
    var currentTag: TagElement? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var pastesList: PastesList = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup notification center
        setupNotifications()

        // Setup view controller
        setupController()
        
        // Fetching data from API
        fetchDataFromAPI()
    }
    
    //MARK: - Setup view
    func setupController() {
        navigationItem.title = "Пасты"

        let tagsButton = UIBarButtonItem(title: "Теги", style: .plain, target: self, action: #selector(tagsButtonPressed))
        navigationItem.rightBarButtonItem = tagsButton
    
        tableView.register(PasteCell.self, forCellReuseIdentifier: "PasteCell")
        tableView.addSubview(refreshControl)

        view.addSubview(tableView)
    }
    
    //MARK: - Request to API
    func fetchDataFromAPI() {
        if let currentTag = currentTag {
            apiParams = [ "tag": "\(currentTag.slug)" ]
        }
        api.pastes(PastesList.self, method: .list, params: apiParams) { (data, error) in
            if let data = data {
                self.pastesList = data
            }
        }
    }
    
    //MARK: - Actions
    @objc
    fileprivate func tagsButtonPressed() {
        navigationController?.pushViewController(TagsViewController(), animated: true)
    }
    
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
}

//MARK: - Notification center
extension PastesViewController {
    //MARK: - Setup
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tagSelected(notification:)),
            name: Notification.Name("SelectTag"),
            object: nil
        )
    }
    
    //MARK: - Selectors
    @objc
    func tagSelected(notification: Notification) {
        if let tag = notification.userInfo?["tag"] as? TagElement {
            currentTag = tag
            self.tableView.setContentOffset(.zero, animated: true)
            fetchDataFromAPI()
        }
    }
}

//MARK: - TableView
extension PastesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.pastesList.count > 0 {
            tableView.backgroundView = nil
            return 1
        } else {
            let tableViewEmptyMessage = TableViewEmptyMessage()
            tableViewEmptyMessage.image = UIImage(named: "pastes")
            tableViewEmptyMessage.title = "Список паст пуст"
            tableViewEmptyMessage.message = "Возможно, вы что-то сделали не так.\nПожалуйста, повторите ещё раз."

            tableView.backgroundView = tableViewEmptyMessage
            tableView.backgroundView?.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pastesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasteCell", for: indexPath) as! PasteCell
        cell.configure(with: self.pastesList[indexPath.row])
        cell.selectionStyle = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pasteViewController = PasteViewController()
        pasteViewController.paste = self.pastesList[indexPath.row]
        navigationController?.pushViewController(pasteViewController, animated: true)
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
