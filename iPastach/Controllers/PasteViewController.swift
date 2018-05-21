//
//  PasteViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 17.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class PasteViewController: UIViewController {
    
    //MARK: - Properties
    lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        return table
    }()
    
    let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShareButton))
    let favoritButton = UIBarButtonItem(image: UIImage(named: "following"), style: .plain, target: self, action: #selector(handleFavoritButton))
    
    //MARK: - API Stuff
    var api: ApiManager = .shared
    
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
        fetchDataFromAPI()
    }

    //MARK: - Setup view
    func setupController() {
        if paste != nil {
            navigationItem.rightBarButtonItems = [favoritButton, shareButton]
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TagCell")
        view.addSubview(tableView)
    }
    
    //MARK: - Request to API
    fileprivate func fetchDataFromAPI(completion: (() -> ())? = nil) {
        var apiParams = [String:String]()
        if let paste = paste {
            apiParams = [ "paste_id": "\(paste.id)" ]
        }
        api.pastes(PasteElement.self, method: .item, params: apiParams) { (data, error) in
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
    func handleShareButton() {
        guard
            let title = paste?.title,
            let url = paste?.url
            else { return }
        let itemsToShare = [title, url] as [Any]
        
        let activityController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityController.excludedActivityTypes = [
            .airDrop,
            .mail,
            .copyToPasteboard,
            .message,
            .postToFacebook,
            .postToTwitter
        ]
        activityController.popoverPresentationController?.sourceView = view
        
        present(activityController, animated: true, completion: nil)
    }
    
    @objc
    func handleFavoritButton() {
        
    }
}
//MARK: - TableView
extension PasteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        return cell
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
