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
        return table
    }()
    
    //MARK: - API Stuff
    var api: ApiManager = .shared
    var apiParams = [String:String]()
    
    //MARK: - Data
    var currentTag: TagElement?
    var pasteList: PastesList = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Хуки контроллера
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view controller
        setupController()
    }
    
    //MARK: - Конфигурация контроллера
    func setupController() {
        navigationItem.title = "Пасты"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PasteCell")
        
        view.addSubview(tableView)
        
        // Fetching data from API
        api.fetch(PastesList.self, method: .pastes, params: apiParams) { (data, error) in
            if let data = data {
                if data.count > 0 {
                    self.pasteList = data
                }
            }
        }
    }
}

extension PastesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pasteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasteCell", for: indexPath)
        cell.textLabel?.text = self.pasteList[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
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
