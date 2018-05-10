//
//  TagsViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController {
    
    //MARK: - Properties
    lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    //MARK: - API Stuff
    var api: ApiManager = .shared

    //MARK: - Data
    var tagsList: TagsList = [] {
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
        navigationItem.title = "Теги"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TagCell")
        
        view.addSubview(tableView)
        
        // Fetching data from API
        api.fetch(TagsList.self, method: .tags) { (data, error) in
            if let data = data {
                if data.count > 0 {
                    self.tagsList = data
                }
            }
        }
    }
}

extension TagsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tagsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath)
        cell.textLabel?.text = self.tagsList[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pastesViewController = PastesViewController()
        pastesViewController.currentTag = self.tagsList[indexPath.row]
        navigationController?.pushViewController(pastesViewController, animated: true)
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
