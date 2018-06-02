//
//  SearchViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = loadMoarButton
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск паст"
        return searchController
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

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    //MARK: - Setup view
    func setupController() {
        navigationItem.title = "Поиск"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = searchController.searchBar
        }

        tableView.register(PasteShortCell.self, forCellReuseIdentifier: "PasteShortCell")
        tableView.addSubview(refreshControl)
        
        view.addSubview(tableView)
    }

    //MARK: - Request to API
    fileprivate func initialLoadFromAPI(completion: (() -> ())? = nil) {
        if let completion = completion {
            completion()
        }
    }
    
    //MARK: - Actions
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        initialLoadFromAPI() {
            refreshControl.endRefreshing()
        }
    }
    
    @objc
    func handleLoadMore(_ sender: UIButton) {
        sender.makeDisabled(true)
        print("loaded!")
    }
}


//MARK: - Search View
extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate {
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
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let tableViewEmptyMessage = TableViewEmptyMessage()
        tableViewEmptyMessage.image = UIImage(named: "search")
        tableViewEmptyMessage.title = "Список паст пуст"
        tableViewEmptyMessage.message = "Возможно, вы что-то сделали не так.\nПожалуйста, повторите ещё раз."
        
        tableView.backgroundView = tableViewEmptyMessage
        tableView.backgroundView?.isHidden = false
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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

