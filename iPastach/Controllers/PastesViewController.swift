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

    var canTransitionToLarge = false
    var canTransitionToSmall = true

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = loadMoarButton
        tableView.refreshControl = refreshControl
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return tableView
    }()

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "IPSearch".translated()
        return searchController
    }()

    lazy var loadMoarButton: UIButton = {
        let loadMoarButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 45))
        loadMoarButton.setTitle("IPLoadmore".translated(), for: .normal)
        loadMoarButton.titleLabel?.font = .systemFont(ofSize: 13)
        loadMoarButton.addTarget(self, action: #selector(self.handleLoadMore(_:)), for: .touchUpInside)
        return loadMoarButton
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var tagsViewController = TagsViewController()
    
    //MARK:  Navigation buttons
    lazy var tagResetButton = UIBarButtonItem(title: "IPReset".translated(), style: .plain, target: self, action: #selector(handleResetTagPressed))
    lazy var tagsSelectButton = UIBarButtonItem(title: "IPTags".translated(), style: .plain, target: self, action: #selector(handleSelectTagPressed))
    
    //MARK:  API Stuff
    var api: APIManager = .shared

    //MARK:  Theme
    lazy var theme: Theme = ThemeManager.shared.currentTheme
    
    //MARK:  AlertsHelper
    var alertsHelper: AlertsHelper = AlertsHelper.shared
    
    //MARK:  Loading
    let progress = IJProgressView.shared
    
    //MARK: - Data

    var currentTag: TagElement?
    var pastes: PastesList = []
    var pagination: Pagination = Pagination(
        first: 0,
        before: 0,
        current: 0,
        last: 0,
        next: 0,
        total_pages: 0,
        total_items: 0,
        limit: "0"
    )
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        setupLongPressGesture()
        setupController()
        progress.showProgressView()
        loadFromAPI() { (data, error) in
            if let newPastes = data?.items {
                self.pastes = newPastes
            }
            DispatchQueue.main.async {
                self.progress.hideProgressView()
                if self.pagination.current == self.pagination.last {
                    self.loadMoarButton.isHidden = true
                } else {
                    self.loadMoarButton.isHidden = false
                }

                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Setup view

    fileprivate func setupController() {
        if let currentTag = currentTag {
            navigationItem.title = currentTag.title
        } else {
            navigationItem.title = "IPApptitle".translated()
        }
        navigationItem.rightBarButtonItems = [tagsSelectButton, tagResetButton]
        extendedLayoutIncludesOpaqueBars = true
        
        //TODO: Выбор темы
        refreshControl.tintColor = theme.tintColor
        loadMoarButton.setTitleColor(theme.tintColor, for: .normal)
        loadMoarButton.setTitleColor(theme.secondTintColor, for: .highlighted)
        tableView.backgroundColor = theme.backgroundColor
        tableView.separatorColor = theme.secondTextColor
        
        tagResetButton.isHidden = true

        tableView.registerCell(PasteShortCell.self)
        view.addSubview(tableView)
    }

    //MARK: - Request to API

    fileprivate func loadFromAPI(by page: Int? = 1, completion: ((PastesListPaginated?, Error?) -> ())? = nil) {
        var apiParams: APIManager.APIParams = [:]
        if let currentTag = currentTag {
            apiParams["tag"] = "\(currentTag.slug)"
        }
        if let page = page, page > 0 {
            apiParams["page"] = "\(page)"
        }
        api.pastes(PastesListPaginated.self, endpoint: .list, params: apiParams) { (data, error) in
            if let error = error {
                print(error)
            }
            if let data = data {
                self.pagination = Pagination(
                    first: data.first,
                    before: data.before,
                    current: data.current,
                    last: data.last,
                    next: data.next,
                    total_pages: data.total_pages,
                    total_items: data.total_items,
                    limit: data.limit
                )
            }
            if let completion = completion {
                completion(data, error)
            }
        }
    }
    
    //MARK: - Actions

    @objc
    func handleSelectTagPressed() {
        navigationController?.pushViewController(self.tagsViewController, animated: true)
    }
    
    @objc
    func handleResetTagPressed(_ sender: UIButton) {
        NotificationCenter.default.post(
            name: .onResetTag,
            object: nil,
            userInfo: nil
        )
    }
    
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadFromAPI() { (data, error) in
            if let newPastes = data?.items {
                self.pastes = newPastes
            }
            DispatchQueue.main.async {
                refreshControl.endRefreshing()
                if self.pagination.current == self.pagination.last {
                    self.loadMoarButton.isHidden = true
                } else {
                    self.loadMoarButton.isHidden = false
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    @objc
    func handleLoadMore(_ sender: UIButton) {
        progress.showProgressView()
        loadFromAPI(by: pagination.next) { (data, error) in
            if let newPastes = data?.items {
                self.pastes.append(contentsOf: newPastes)
            }
            DispatchQueue.main.async {
                self.progress.hideProgressView()
                if self.pagination.current == self.pagination.last {
                    sender.isHidden = true
                } else {
                    sender.isHidden = false
                }
                self.tableView.reload()
            }
        }
    }
}

//MARK: - Notification center

extension PastesViewController {
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tagSelected(notification:)),
            name: .onSelectTag,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tagReseted(notification:)),
            name: .onResetTag,
            object: nil
        )
    }

    @objc
    func tagSelected(notification: Notification) {
        guard let tag = notification.userInfo?["tag"] as? TagElement else { return }
        currentTag = tag
        progress.showProgressView()
        loadFromAPI() { (data, error) in
            if let newPastes = data?.items {
                self.pastes = newPastes
            }
            DispatchQueue.main.async {
                self.navigationItem.title = tag.title
                self.tagResetButton.isHidden = false
                self.progress.hideProgressView()
                if self.pagination.current == self.pagination.last {
                    self.loadMoarButton.isHidden = true
                } else {
                    self.loadMoarButton.isHidden = false
                }

                self.tableView.reloadData()
            }
        }
    }

    @objc
    func tagReseted(notification: Notification) {
        currentTag = nil
        progress.showProgressView()
        loadFromAPI() { (data, error) in
            if let newPastes = data?.items {
                self.pastes = newPastes
            }
            DispatchQueue.main.async {
                self.navigationItem.title = "IPApptitle".translated()
                self.tagResetButton.isHidden = true
                self.progress.hideProgressView()
                if self.pagination.current == self.pagination.last {
                    self.loadMoarButton.isHidden = true
                } else {
                    self.loadMoarButton.isHidden = false
                }
                
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Gesture

extension PastesViewController: UIGestureRecognizerDelegate {
    func setupLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }

    @objc
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let item = AlertStruct(
                    title: "IPSelectAnAction".translated()
                )
                let shareAction = UIAlertAction(title: "IPShare".translated(), style: .default) { action in
                    print(action)
                }
                let favoritAction = UIAlertAction(title: "IPFavorite".translated(), style: .default) { action in
                    print(action)
                }
                let canceltAction = UIAlertAction(title: "IPCancel".translated(), style: .cancel) { action in
                    print(action)
                }
                alertsHelper.actionOn(self, item: item, actions: [
                    shareAction,
                    favoritAction,
                    canceltAction
                ])
            }
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

//MARK: - ScrollView

extension PastesViewController: UIScrollViewDelegate {
    func changeNavigationBarOnScroll(_ scrollView: UIScrollView) -> Void {
        guard let navigationBarHeight = self.navigationController?.navigationBar.bounds.height else { return }
        if canTransitionToLarge && scrollView.contentOffset.y <= 0 - navigationBarHeight {
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.navigationBar.isTranslucent = false
            }
            canTransitionToLarge = false
            canTransitionToSmall = true
        }
        else if canTransitionToSmall && scrollView.contentOffset.y > 0 - navigationBarHeight {
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.navigationBar.isTranslucent = true
            }
            canTransitionToLarge = true
            canTransitionToSmall = false
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeNavigationBarOnScroll(scrollView)
    }
}

//MARK: - TableView

extension PastesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if !pastes.isEmpty {
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
        return pastes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(PasteShortCell.self)
        cell.configure(with: pastes[indexPath.row])
        cell.customSelectColor(theme.selectColor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pasteViewController = PasteViewController()
        pasteViewController.paste = pastes[indexPath.row]
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
