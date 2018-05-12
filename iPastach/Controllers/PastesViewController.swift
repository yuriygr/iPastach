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
    var pastesList: PastesList = [
        PasteElement(id: 456, title: "Он появился ниоткуда", time: "25 Февраля 2018 в 22:24", description: "Ну давай, сложи свои три пальца на руке и покрестись. Поплачь перед ликом \"святым\". Легче стало? Он появился ниоткуда,и так же исчез. Он может все и поможет нам. Он свет и он сидит на небе в облаках. Да как? как верить в такой бред можно?...", nsfw: false),
        PasteElement(id: 455, title: "Helfen Sie mir, bitte!", time: "25 Февраля 2018 в 21:19", description: "Так и вижу упоительную картину: тесный квадратный дворик с высокими стенами и единственной стальной дверью, клочок девственно голубого голландского неба (вот, разве что, малое облачко запуталось в спиралях колючей проволоки), чахлый подорож...", nsfw: false),
        PasteElement(id: 454, title: "Кирилл", time: "25 Февраля 2018 в 21:00", description: "Суп /b/. Меня зовут Кирилл. Я вас всех ненавижу. Ну вот получилось невежливо. Давайте с начала? Суп, меня зовут Кирилл. Мне 17 лет, я ростом в 184 сантиметра и весом в 80 кг. У меня мышиного цвета волосы и голубые глаза. Я вощемта обычный ч...", nsfw: false),
        PasteElement(id: 453, title: "Хочу поделиться соображениями", time: "25 Февраля 2018 в 20:57", description: "8 лет на дваче. И я хочу поделится своими соображениями. Я попал на тот самый двач в конце 2006, скажу честно, я на нем практически не сидел, потому что были и куда более приятные форумы, с более приятными людьми, правда они были не аноним...", nsfw: false)
        ] {
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
        navigationItem.leftBarButtonItem = tagsButton
        
        tableView.register(PasteCell.self, forCellReuseIdentifier: "PasteCell")

        view.addSubview(tableView)
        
        // Fetching data from API
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
}

extension PastesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.pastesList.count > 0 {
            tableView.backgroundView = nil
            return 1
        } else {
            let placeholderView = PlaceholderView()
            placeholderView.image = UIImage(named: "error")
            placeholderView.title = "Список паст пуст"
            placeholderView.message = "Возможно, вы что-то сделали не так. Пожалуйста, повторите ещё раз."

            tableView.backgroundView = placeholderView
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
