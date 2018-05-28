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
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShareButton))
    let favoritButton = UIBarButtonItem(image: UIImage(named: "following"), style: .plain, target: self, action: #selector(handleFavoritButton))
    
    //MARK: - API Stuff
    var api: APIManager = .shared
    
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
        navigationItem.rightBarButtonItems = [favoritButton, shareButton]

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TagCell")
        view.addSubview(tableView)
    }
    
    //MARK: - Request to API
    fileprivate func fetchDataFromAPI(completion: (() -> ())? = nil) {
        var apiParams = [String:String]()
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = self.paste?.title
            cell.textLabel?.font = .boldSystemFont(ofSize: 18.0)
            cell.textLabel?.textColor = .mainText
            cell.textLabel?.lineBreakMode = .byWordWrapping

            cell.detailTextLabel?.text = self.paste?.formatedTime()
            cell.detailTextLabel?.font = .systemFont(ofSize: 12)
            cell.detailTextLabel?.textColor = .mainGrey
            cell.detailTextLabel?.lineBreakMode = .byWordWrapping

            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 1 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = self.paste?.description
            cell.textLabel?.font = .systemFont(ofSize: 15)
            cell.textLabel?.textColor = .mainText
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
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
            return 0.01
        }
    }
}
