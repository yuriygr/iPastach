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
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = loadMoarButton
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return tableView
    }()

    lazy var loadMoarButton: UIButton = {
        let loadMoarButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 45))
        loadMoarButton.setTitle("Загрузить ещё", for: .normal)
        loadMoarButton.setTitleColor(.mainBlue, for: .normal)
        loadMoarButton.titleLabel?.font = .systemFont(ofSize: 13)
        loadMoarButton.addTarget(self, action: #selector(self.handleLoadMore(_:)), for: .touchUpInside)
        return loadMoarButton
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .mainBlue
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var tagsViewController = TagsViewController()
    
    lazy var tagResetButton = UIBarButtonItem(title: "Сбросить", style: .plain, target: self, action: #selector(handleResetTag))
    lazy var tagsSelectButton = UIBarButtonItem(title: "Теги", style: .plain, target: self, action: #selector(handleTagsSelect))
    
    //MARK: - API Stuff
    var api: APIManager = .shared
    
    //MARK: - Data
    var currentTag: TagElement? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var pastesListPaginated: PastesListPaginated? {
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
        initialLoadFromAPI()
    }
    
    //MARK: - Setup view
    fileprivate func setupController() {
        navigationItem.title = "Паста.ч"
        navigationItem.rightBarButtonItem = tagsSelectButton
        navigationItem.leftBarButtonItem = tagResetButton
        navigationItem.withoutNameBackButton()
        tagResetButton.isEnabled = false

        tableView.register(PasteShortCell.self, forCellReuseIdentifier: "PasteShortCell")
        tableView.addSubview(refreshControl)
        
        view.addSubview(tableView)
    }
    
    //MARK: - Request to API
    fileprivate func initialLoadFromAPI(completion: (() -> ())? = nil) {
        var apiParams: APIManager.APIParams = [:]
        if let currentTag = currentTag {
            apiParams["tag"] = "\(currentTag.slug)"
        }
        api.pastes(PastesListPaginated.self, endpoint: .list, params: apiParams) { (data, error) in
            if let data = data {
                self.pastesListPaginated = data
            }
            if let completion = completion {
                completion()
            }
        }
    }
    // Мама, не бей меня
    fileprivate func loadFromAPI(by page: Int?, completion: (() -> ())? = nil) {
        var apiParams: APIManager.APIParams = [:]
        if let currentTag = currentTag {
            apiParams["tag"] = "\(currentTag.slug)"
        }
        if let page = page, page > 0 {
            apiParams["page"] = "\(page)"
        }
        api.pastes(PastesListPaginated.self, endpoint: .list, params: apiParams) { (data, error) in
            if let data = data {
                self.pastesListPaginated?.items = (self.pastesListPaginated?.items)! + data.items!
                self.pastesListPaginated?.first = data.first
                self.pastesListPaginated?.before = data.before
                self.pastesListPaginated?.current = data.current
                self.pastesListPaginated?.last = data.last
                self.pastesListPaginated?.next = data.next
                self.pastesListPaginated?.total_pages = data.total_pages
                self.pastesListPaginated?.total_items = data.total_items
                self.pastesListPaginated?.limit = data.limit
            }
            if let completion = completion {
                completion()
            }
        }
    }
    
    //MARK: - Actions

    @objc
    func handleTagsSelect() {
        navigationController?.pushViewController(self.tagsViewController, animated: true)
    }
    
    @objc
    func handleResetTag() {
        currentTag = nil
        navigationItem.title = "Пасты"
        tagResetButton.isEnabled = false
        //tableView.setContentOffset(.zero, animated: true)
        initialLoadFromAPI()
    }
    
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        initialLoadFromAPI() {
            refreshControl.endRefreshing()
        }
    }
    
    @objc
    func handleLoadMore(_ sender: UIButton) {
        loadFromAPI(by: pastesListPaginated?.next) {
            if self.pastesListPaginated?.current == self.pastesListPaginated?.last {
                sender.makeDisabled(true)
            }
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
            initialLoadFromAPI()
        }
    }
}

//MARK: - Search View
extension PastesViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationController?.navigationBar.isTranslucent = false
    }
}

//MARK: - TableView
extension PastesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let items = self.pastesListPaginated?.items, !items.isEmpty {
            tableView.backgroundView = nil
            tableView.tableFooterView = loadMoarButton
            return 1
        } else {
            let tableViewEmptyMessage = TableViewEmptyMessage()
            tableViewEmptyMessage.image = UIImage(named: "pastes")
            tableViewEmptyMessage.title = "Список паст пуст"
            tableViewEmptyMessage.message = "Возможно, вы что-то сделали не так.\nПожалуйста, повторите ещё раз."

            tableView.backgroundView = tableViewEmptyMessage
            tableView.backgroundView?.isHidden = false
            tableView.tableFooterView = UIView()
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = self.pastesListPaginated?.items else { return 0 }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = self.pastesListPaginated?.items else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasteShortCell", for: indexPath) as! PasteShortCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let items = self.pastesListPaginated?.items else { return }
        let pasteViewController = PasteViewController()
        pasteViewController.paste = items[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return tableView.sectionHeaderHeight
        } else {
            return 0.01
        }
    }
}
