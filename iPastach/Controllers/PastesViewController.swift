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
        return refreshControl
    }()
    
    lazy var tagResetButton = UIBarButtonItem(title: "Сбросить", style: .plain, target: self, action: #selector(handleResetTag))
    lazy var tagsSelectButton = UIBarButtonItem(title: "Теги", style: .plain, target: self, action: #selector(handleTagsSelectButton))
    
    //MARK: - API Stuff
    var api: ApiManager = .shared
    
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
        setupNotifications()
        setupController()
        fetchDataFromAPI()
    }
    
    //MARK: - Setup view
    fileprivate func setupController() {
        navigationItem.title = "Пасты"
        tagResetButton.isEnabled = false
        navigationItem.rightBarButtonItem = tagsSelectButton
        navigationItem.leftBarButtonItem = tagResetButton
        
        tableView.register(PasteCell.self, forCellReuseIdentifier: "PasteCell")
        tableView.addSubview(refreshControl)

        view.addSubview(tableView)
    }
    
    //MARK: - Request to API
    fileprivate func fetchDataFromAPI(completion: (() -> ())? = nil) {
        var apiParams = [String:String]()
        if let currentTag = currentTag {
            apiParams = [ "tag": "\(currentTag.slug)" ]
        }
        api.pastes(PastesList.self, method: .list, params: apiParams) { (data, error) in
            if let data = data {
                self.pastesList = data
            }
            if let completion = completion {
                completion()
            }
        }
    }
    
    //MARK: - Actions
    @objc
    fileprivate func handleTagsSelectButton() {
        navigationController?.pushViewController(TagsViewController(), animated: true)
    }
    
    @objc
    func handleResetTag() {
        currentTag = nil
        navigationItem.title = "Пасты"
        tagResetButton.isEnabled = false
        //tableView.setContentOffset(.zero, animated: true)
        fetchDataFromAPI()
    }
    
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchDataFromAPI() {
            refreshControl.endRefreshing()
        }
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
            navigationItem.title = tag.title
            tagResetButton.isEnabled = true
            tableView.setContentOffset(.zero, animated: true)
            fetchDataFromAPI()
        }
    }
}

//MARK: - TableView
extension PastesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !self.pastesList.isEmpty {
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
