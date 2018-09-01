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
    private var theme = UserSettings.shared.currentTheme
    
    //MARK: - Properties

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = loadMoarButton
        tableView.refreshControl = refreshControl
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.registerCell(PasteShortCell.self)
        return tableView
    }()

    lazy var loadMoarButton: LoadMoreButton = {
        let loadMoarButton = LoadMoreButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        loadMoarButton.setTitle("IPLoadmore".localized, for: .normal)
        loadMoarButton.titleLabel?.font = .systemFont(ofSize: 13)
        loadMoarButton.addTarget(self, action: #selector(handleLoadMore(_:)), for: .touchUpInside)
        return loadMoarButton
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()

    private lazy var addPasteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleAddPastePressed))
    private lazy var tagResetButton = UIBarButtonItem(title: "IPReset".localized, style: .plain, target: self, action: #selector(handleResetTagPressed))
    private lazy var tagsSelectButton = UIBarButtonItem(title: "IPTags".localized, style: .plain, target: self, action: #selector(handleSelectTagPressed))

    private lazy var tagsViewController = TagsViewController()
    private lazy var addPasteViewController = UINavigationController(rootViewController: AddPasteViewController())
    
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
                    self.tableView.tableFooterView = UIView()
                } else {
                    self.tableView.tableFooterView = self.loadMoarButton
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
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - Setup's

    private func setupController() {
        navigationItem.title = currentTag?.title ?? "IPApptitle".localized
        navigationItem.leftBarButtonItems = [addPasteButton]
        navigationItem.rightBarButtonItems = [tagsSelectButton, tagResetButton]
        navigationItem.withoutTitleOnBackBarButton = true
        extendedLayoutIncludesOpaqueBars = true
        tagResetButton.isHidden = true
        view.addSubview(tableView)
    }

    private func setupTheme() {
        view.backgroundColor = theme.secondBackgroundColor
        loadMoarButton.setTitleColor(theme.tintColor, for: .normal)
        loadMoarButton.setTitleColor(theme.secondTintColor, for: .highlighted)
        loadMoarButton.setIndicatorColor(theme.secondTextColor)
        tableView.backgroundColor = theme.secondBackgroundColor
        tableView.separatorColor = theme.separatorColor
        refreshControl.tintColor = theme.secondTextColor
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
        api.fetch(PastesListPaginated.self, method: .pastes(.list), params: apiParams) { (data, error) in
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
    func handleLoadMore(_ sender: LoadMoreButton) {
        sender.showLoading()
        loadFromAPI(by: pagination.next) { (data, error) in
            if let newPastes = data?.items {
                self.pastes.append(contentsOf: newPastes)
            }
            DispatchQueue.main.async {
                sender.hideLoading()
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
                self.tableView.scrollToTop()
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
                self.navigationItem.title = "IPApptitle".localized
                self.tagResetButton.isHidden = true
                IJProgressView.shared.hideProgressView()
                if self.pagination.current == self.pagination.last {
                    self.loadMoarButton.isHidden = true
                } else {
                    self.loadMoarButton.isHidden = false
                }
                self.tableView.scrollToTop()
                self.tableView.reload()
            }
        }
    }
}

//MARK: - Gesture

extension PastesViewController: UIGestureRecognizerDelegate {
    
    func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }

    @objc
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            guard let indexPath = tableView.indexPathForRow(at: touchPoint) else { return }
 
            let shareAction = UIAlertAction(title: "IPShare".localized, style: .default) { action in
                print(indexPath)
            }
            let likeAction = UIAlertAction(title: "IPLike".localized, style: .default) { action in
                print(indexPath)
            }
            let favoritAction = UIAlertAction(title: "IPFavorite".localized, style: .default) { action in
                print(indexPath)
            }
            let complaintAction = UIAlertAction(title: "IPСomplaint".localized, style: .default) { action in
                print(indexPath)
            }
            let cancelAction = UIAlertAction(title: "IPCancel".localized, style: .cancel) { action in
                print(indexPath)
            }
            AlertsHelper.shared.actionOn(self, actions: [
                shareAction,
                likeAction,
                favoritAction,
                complaintAction,
                cancelAction
            ])
        }
    }
}


//MARK: - ScrollView Delegate

extension PastesViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}

//MARK: - TableView Delegate

extension PastesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if !pastes.isEmpty {
            tableView.backgroundView = nil
            tableView.tableFooterView = loadMoarButton
            return pastes.count
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

    func isNotEmptySection(_ tableView: UITableView, _ section: Int) -> Bool {
        return self.tableView(tableView, numberOfRowsInSection: section) > 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(PasteShortCell.self)
        cell.bind(data: pastes[indexPath.section])
        cell.setupTheme()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pasteViewController = PasteViewController()
        pasteViewController.paste = pastes[indexPath.section]
        pasteViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(pasteViewController, animated: true)
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
        if #available(iOS 11.0, *) {
            return 0.0
        } else {
            return 0.001
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

