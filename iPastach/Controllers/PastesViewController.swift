//
//  PastesViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class PastesViewController: UIViewController {
    
    private var api: APIManager = .shared
    private lazy var theme = UserSettings.shared.currentTheme
    
    //MARK: - Properties

    var canTransitionToLarge = false
    var canTransitionToSmall = true

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = loadMoarButton
        tableView.refreshControl = refreshControl
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.registerCell(PasteShortCell.self)
        return tableView
    }()
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "IPSearch".translated()
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
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

    lazy var addPasteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddPastePressed))
    lazy var searchPasteButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchPressed))
    lazy var tagResetButton = UIBarButtonItem(title: "IPReset".translated(), style: .plain, target: self, action: #selector(handleResetTagPressed))
    lazy var tagsSelectButton = UIBarButtonItem(title: "IPTags".translated(), style: .plain, target: self, action: #selector(handleSelectTagPressed))

    lazy var tagsViewController = TagsViewController()
    lazy var addPasteViewController = UINavigationController(rootViewController: AddPasteViewController())
    
    //MARK: - Data

    var currentTag: Tag?
    var pastes: [Paste] = []
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
    var isFavorites = false
    private var isSearching: Bool {
        return searchController.isActive && !(searchController.searchBar.text ?? "").isEmpty
    }
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        setupLongPressGesture()
        setupController()
        IJProgressView.shared.showProgressView()
        loadFromAPI() { (data, error) in
            if let newPastes = data?.items {
                self.pastes = newPastes
            }
            DispatchQueue.main.async {
                IJProgressView.shared.hideProgressView()
                if self.pagination.current == self.pagination.last {
                    self.loadMoarButton.isHidden = true
                } else {
                    self.loadMoarButton.isHidden = false
                }

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
        searchController.isActive = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - Setup's

    private func setupController() {
        navigationItem.title = currentTag?.title ?? (isFavorites ? "IPFavorites".translated() : "IPApptitle".translated())
        navigationItem.leftBarButtonItems = [addPasteButton, searchPasteButton]
        navigationItem.rightBarButtonItems = [tagsSelectButton, tagResetButton]
        navigationItem.withoutNameBackButton()
        extendedLayoutIncludesOpaqueBars = true
        tagResetButton.isHidden = true
        view.addSubview(tableView)
    }

    private func setupTheme() {
        view.backgroundColor = theme.backgroundColor
        refreshControl.tintColor = theme.tintColor
        loadMoarButton.setTitleColor(theme.tintColor, for: .normal)
        loadMoarButton.setTitleColor(theme.secondTintColor, for: .highlighted)
        tableView.backgroundColor = theme.backgroundColor
        tableView.separatorColor = theme.separatorColor
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.backgroundColor = theme.backgroundColor
    }
    
    //MARK: - Request to API

    private func loadFromAPI(by page: Int? = 1, completion: ((PastesListPaginated?, Error?) -> ())? = nil) {
        var apiParams: APIParams = [:]
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
    func handleAddPastePressed() {
        present(addPasteViewController, animated: true, completion: nil)
    }
    
    @objc
    func handleSearchPressed() {
        searchController.searchBar.keyboardType = .asciiCapable
        present(searchController, animated: true, completion: nil)
    }
    
    @objc
    func handleSelectTagPressed() {
        navigationController?.pushViewController(tagsViewController, animated: true)
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
        IJProgressView.shared.showProgressView()
        loadFromAPI(by: pagination.next) { (data, error) in
            if let newPastes = data?.items {
                self.pastes.append(contentsOf: newPastes)
            }
            DispatchQueue.main.async {
                IJProgressView.shared.hideProgressView()
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
    private func setupNotifications() {
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
        guard let tag = notification.userInfo?["tag"] as? Tag else { return }
        currentTag = tag
        IJProgressView.shared.showProgressView()
        loadFromAPI() { (data, error) in
            if let newPastes = data?.items {
                self.pastes = newPastes
            }
            DispatchQueue.main.async {
                self.navigationItem.title = tag.title
                self.tagResetButton.isHidden = false
                IJProgressView.shared.hideProgressView()
                if self.pagination.current == self.pagination.last {
                    self.loadMoarButton.isHidden = true
                } else {
                    self.loadMoarButton.isHidden = false
                }
                self.tableView.scrollsToTop = true
                self.tableView.reload()
            }
        }
    }

    @objc
    func tagReseted(notification: Notification) {
        currentTag = nil
        IJProgressView.shared.showProgressView()
        loadFromAPI() { (data, error) in
            if let newPastes = data?.items {
                self.pastes = newPastes
            }
            DispatchQueue.main.async {
                self.navigationItem.title = "IPApptitle".translated()
                self.tagResetButton.isHidden = true
                IJProgressView.shared.hideProgressView()
                if self.pagination.current == self.pagination.last {
                    self.loadMoarButton.isHidden = true
                } else {
                    self.loadMoarButton.isHidden = false
                }
                self.tableView.scrollsToTop = true
                self.tableView.reload()
            }
        }
    }
}

//MARK: - Gesture

extension PastesViewController: UIGestureRecognizerDelegate {
    func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }

    @objc
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            guard let indexPath = tableView.indexPathForRow(at: touchPoint) else { return }
            let item = AlertStruct(
                title: "IPSelectAnAction".translated()
            )
            let shareAction = UIAlertAction(title: "IPShare".translated(), style: .default) { action in
                print(indexPath)
            }
            let favoritAction = UIAlertAction(title: "IPFavorite".translated(), style: .default) { action in
                print(indexPath)
            }
            let likeAction = UIAlertAction(title: "IPLike".translated(), style: .default) { action in
                print(indexPath)
            }
            let cancelAction = UIAlertAction(title: "IPCancel".translated(), style: .cancel) { action in
                print(indexPath)
            }
            AlertsHelper.shared.actionOn(self, item: item, actions: [
                shareAction,
                favoritAction,
                likeAction,
                cancelAction
            ])
        }
    }
}

//MARK: - Search View

extension PastesViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
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

//MARK: - ScrollView Delegate

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

//MARK: - TableView Delegate

extension PastesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if !pastes.isEmpty {
            tableView.backgroundView = nil
            tableView.tableFooterView = loadMoarButton
            return 1
        } else {
            let tableViewEmptyMessage = TableViewEmptyMessage()
            if isFavorites {
                tableViewEmptyMessage.image = UIImage(named: "following")
                tableViewEmptyMessage.title = "Избранное отсутствует"
                tableViewEmptyMessage.message = "Вы можете добавить пасты в избранное,\nнажав соответствующую кнопку."
            } else {
                tableViewEmptyMessage.image = UIImage(named: "pastes")
                tableViewEmptyMessage.title = "Список паст пуст"
                tableViewEmptyMessage.message = "Возможно, вы что-то сделали не так.\nПожалуйста, повторите ещё раз."
            }
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
        pasteViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(pasteViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
