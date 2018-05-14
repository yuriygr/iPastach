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
        return table
    }()
    
    //MARK: - API Stuff
    var api: ApiManager = .shared
    var apiParams = [String:String]()
    
    //MARK: - Data
    var currentTag: TagElement?
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
        
        // Setup view controller
        setupController()
    }
    
    //MARK: - Конфигурация контроллера
    func setupController() {
        navigationItem.title = "Пасты"
    
        let tagsButton = UIBarButtonItem(title: "Теги", style: .plain, target: self, action: #selector(tagsButtonPressed))
        navigationItem.rightBarButtonItem = tagsButton
    
        tableView.register(PasteCell.self, forCellReuseIdentifier: "PasteCell")

        view.addSubview(tableView)
        
        // Fetching data from API
        if let currentTag = currentTag {
            apiParams = [ "tag": "\(currentTag.slug)" ]
        }
        api.fetch(PastesList.self, method: .pastes, params: apiParams) { (data, error) in
            if let data = data {
                if data.count > 0 {
                    self.pastesList = data
                }
            }
        }
    }
    
    //MARK: - Actions
    @objc
    fileprivate func tagsButtonPressed() {
        navigationController?.pushViewController(TagsViewController(), animated: true)
    }
    @objc
    fileprivate func refreshButtonPressed() {
        
    }
}

extension PastesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.pastesList.count > 0 {
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let pasteViewController = PasteViewController()
        //pasteViewController.paste = self.pasteList[indexPath.row]
        //navigationController?.pushViewController(pasteViewController, animated: true)
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
