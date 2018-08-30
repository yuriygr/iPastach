//
//  PasteViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 17.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//
//TODO: https://stackoverflow.com/questions/30849030/swift-how-to-execute-an-action-when-uitabbaritem-is-pressed/30849225

import UIKit

class PasteViewController: UIViewController {
    
    private var api: APIManager = .shared
    private var theme = UserSettings.shared.currentTheme
    private let activity = NSUserActivity(activityType: "gr.yuriy.iPastach.openPastePage")
    private let toolbarFactory = ToolbarItemsFactory(items: [
        .like, .favorites, .random, .copy, .complaint
    ])

    //MARK: - Properties

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.registerCell(PasteFullHeaderCell.self)
        tableView.registerCell(PasteFullContentCell.self)
        return tableView
    }()
    
    lazy var shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonPressed))

    //MARK: - Data

    var paste: Paste?
    
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
        setupActivity()
        setupTheme()
        setupToolbar()
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        activity.invalidate()
        navigationController?.setToolbarHidden(true, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - Setup's

    func setupController() {
        navigationItem.rightBarButtonItem = shareButton
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        extendedLayoutIncludesOpaqueBars = true
        view.addSubview(tableView)
    }
    
    private func loadFromAPI(completion: ((Paste?, Error?) -> ())? = nil) {
        var apiParams: APIParams = [:]
        if let paste = paste {
            apiParams = [ "paste_id": "\(paste.id)" ]
        }
        
        api.fetch(Paste.self, method: .pastes(.item), params: apiParams) { (data, error) in
            if let error = error {
                print(error)
            }
            if let data = data {
                self.paste = data
            }
            if let completion = completion {
                completion(data, error)
            }
        }
    }
    
    private func setupActivity() {
        guard let url = URL(string: paste!.url) else { return }
        activity.webpageURL = url
        activity.isEligibleForHandoff = true
        activity.isEligibleForSearch = true
        activity.isEligibleForPublicIndexing = true
        activity.becomeCurrent()
        userActivity = activity
    }

    private func setupTheme() {
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.backgroundColor
    }
    
    private func setupToolbar() {
        toolbarFactory.delegate = self
        let items = toolbarFactory.makeBarItems()
        setToolbarItems(items, animated: false)
    }
    
    //MARK: - Actions
    
    @objc
    func shareButtonPressed(_ sender: UIButton) {
        guard
            let paste = paste,
            let url = URL(string: paste.url) else { return }
        let items = [
            paste.title, url
        ] as [Any]
    
        AlertsHelper.shared.shareOn(self, items: items)

        NotificationCenter.default.post(
            name: .onPasteShared,
            object: nil,
            userInfo: ["paste": paste]
        )
    }
    
    func likeButtonTapped(_ sender: UIBarButtonItem) {
        guard let paste = paste else { return }

        api.fetch(APIResponse.self, method: .pastes(.like), params: [ "paste_id": "\(paste.id)" ]) { (data, error) in
            if let error = error {
                AlertsHelper.shared.alertOn(self, title: "IPError".localized, message: error.localizedDescription, actions: [
                    UIAlertAction(title: "IPClose".localized, style: .default)
                ])
            }
            if let data = data {
                if let error = data.error {
                    AlertsHelper.shared.alertOn(self, title: "IPError".localized, message: error.errorMessage, actions: [
                        UIAlertAction(title: "IPClose".localized, style: .default)
                    ])
                }
                if let _ = data.success {
                    AlertsHelper.shared.alertOn(self, title: "IPPasteLiked".localized, actions: [
                        UIAlertAction(title: "IPClose".localized, style: .default)
                    ])
                }
            }
        }
    }

    func favoritButtonTapped(_ sender: UIBarButtonItem) {
        guard let paste = paste else { return }

        let closeAction = UIAlertAction(title: "IPClose".localized, style: .default)
        let cancelAction = UIAlertAction(title: "IPCancel".localized, style: .default) { action in
            NotificationCenter.default.post(
                name: .onPasteRemoveFromFavorite,
                object: nil,
                userInfo: ["paste": paste]
            )
        }
        AlertsHelper.shared.alertOn(self, title: "IPPasteAddedToFavorits".localized, actions: [
            closeAction,
            cancelAction
        ])

        NotificationCenter.default.post(
            name: .onPasteAddToFavorite,
            object: nil,
            userInfo: ["paste": paste]
        )
    }

    func randomButtonTapped(_ sender: UIBarButtonItem) {
        IJProgressView.shared.showProgressView()
        api.fetch(Paste.self, method: .pastes(.random)) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                self.paste = data
            }
            DispatchQueue.main.async {
                IJProgressView.shared.hideProgressView()
                self.tableView.reload()
            }
        }
    }
    
    func copyButtonTapped(_ sender: UIBarButtonItem) {
        guard let paste = paste else { return }
        UIPasteboard.general.string = paste.content
        
        AlertsHelper.shared.alertOn(self, title: "IPCopiedToClipboard".localized, actions: [
            UIAlertAction(title: "IPClose".localized, style: .default)
        ])
    }

    func complaintButtonTapped(_ sender: UIBarButtonItem) {
        guard let paste = paste else { return }
    
        api.fetch(APIResponse.self, method: .pastes(.complaint), params: [ "paste_id": "\(paste.id)" ]) { (data, error) in
            if let error = error {
                AlertsHelper.shared.alertOn(self, title: "IPError".localized, message: error.localizedDescription, actions: [
                    UIAlertAction(title: "IPClose".localized, style: .default)
                ])
            }
            if let data = data {
                if let error = data.error {
                    AlertsHelper.shared.alertOn(self, title: "IPError".localized, message: error.errorMessage, actions: [
                        UIAlertAction(title: "IPClose".localized, style: .default)
                    ])
                }
                if let _ = data.success {
                    AlertsHelper.shared.alertOn(self, title: "IPComplaintSent".localized, actions: [
                        UIAlertAction(title: "IPClose".localized, style: .default)
                    ]) {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Toolbar Delegate

extension PasteViewController: ToolbarItemsFactoryDelegate {
    
    func itemTapped(_ sender: ToolbarItemsFactory, item: ToolbarItem, barItem: UIBarButtonItem) {
        switch item {
        case .like:
            likeButtonTapped(barItem)
        case .favorites:
            favoritButtonTapped(barItem)
        case .random:
            randomButtonTapped(barItem)
        case .copy:
            copyButtonTapped(barItem)
        case .complaint:
            complaintButtonTapped(barItem)
        default:
            break
        }
    }
}

//MARK: - ScrollView Delegate

extension PasteViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}

//MARK: - TableView Delegate

extension PasteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.paste != nil {
            tableView.backgroundView = nil
            return 1
        } else {
            let tableViewEmptyMessage = TableViewEmptyMessage()
            tableViewEmptyMessage.image = UIImage(named: "pastes")
            tableViewEmptyMessage.title = "Пасты нет"
            tableViewEmptyMessage.message = "Возможно, вы что-то сделали не так.\nПожалуйста, повторите ещё раз."
            
            tableView.backgroundView = tableViewEmptyMessage
            tableView.backgroundView?.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let paste = self.paste else { return UITableViewCell() }
        switch PasteTableSection(rawValue: indexPath.row) {
        case .header?:
            let cell = tableView.dequeueCell(PasteFullHeaderCell.self)
            cell.configure(with: paste)
            return cell
        case .content?, nil:
            let cell = tableView.dequeueCell(PasteFullContentCell.self)
            cell.configure(with: paste)
            return cell
        }
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
