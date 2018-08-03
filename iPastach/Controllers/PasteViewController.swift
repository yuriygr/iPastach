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
    
    //MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    lazy var shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonPressed))
    lazy var favoritButton = UIBarButtonItem(image: UIImage(named: "star"), style: .plain, target: self, action: #selector(favoritButtonPressed))
    
    //MARK:  API Stuff
    var api: APIManager = .shared
    
    //MARK:  Theme
    lazy var theme: Theme = ThemeManager.shared.currentTheme

    //MARK:  AlertsHelper
    var alertsHelper: AlertsHelper = AlertsHelper.shared

    //MARK: - Data
    var paste: PasteElement? {
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
        initialLoadFromAPI()
    }

    //MARK: - Setup view
    func setupController() {
        navigationItem.rightBarButtonItems = [favoritButton, shareButton]
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        extendedLayoutIncludesOpaqueBars = true

        //TODO: Выбор темы
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.backgroundColor
        
        tableView.registerCell(PasteFullHeaderCell.self)
        tableView.registerCell(PasteFullContentCell.self)
        view.addSubview(tableView)
    }
    
    //MARK: - Request to API
    fileprivate func initialLoadFromAPI(completion: (() -> ())? = nil) {
        var apiParams: APIManager.APIParams = [:]
        if let paste = paste {
            apiParams = [ "paste_id": "\(paste.id)" ]
        } else {
            apiParams = [ "type": "random" ]
        }
        
        api.pastes(PasteElement.self, endpoint: .item, params: apiParams) { (data, error) in
            if let data = data {
                self.paste = data
            }
            if let completion = completion {
                completion()
            }
        }
    }
    
    //MARK: - Actions
    
    @objc
    func shareButtonPressed(_ sender: UIButton) {
        guard let paste = paste else { return }
        let items = [
            paste.title, paste.url
        ]
    
        alertsHelper.shareOn(self, items: items)

        NotificationCenter.default.post(
            name: .onPasteShared,
            object: nil,
            userInfo: ["paste": paste]
        )
    }
    
    @objc
    func favoritButtonPressed(_ sender: UIButton) {
        guard let paste = paste else { return }
        let item = AlertStruct(
            title: "IPPasteAddedToFavorits".translated()
        )
        let closeAction = UIAlertAction(title: "IPClose".translated(), style: .default)
        let cancelAction = UIAlertAction(title: "IPCancel".translated(), style: .default) { action in
            NotificationCenter.default.post(
                name: .onPasteRemoveFromFavorite,
                object: nil,
                userInfo: ["paste": paste]
            )
        }
        alertsHelper.alertOn(self, item: item, actions: [
            closeAction,
            cancelAction
        ])

        NotificationCenter.default.post(
            name: .onPasteAddToFavorite,
            object: nil,
            userInfo: ["paste": paste]
        )
    }
}
//MARK: - TableView
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
        if indexPath.row == 0 {
            let cell = tableView.dequeueCell(PasteFullHeaderCell.self)
            cell.configure(with: paste)
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueCell(PasteFullContentCell.self)
            cell.configure(with: paste)
            return cell
        }
        return UITableViewCell()
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
