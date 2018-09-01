//
//  AddPasteViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 02.08.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class AddPasteViewController: UIViewController {
    
    private var api: APIManager = .shared
    private var theme = UserSettings.shared.currentTheme
    
    //MARK: - Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        return tableView
    }()

    private lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(handleCancelPressed))
    private lazy var postButton = UIBarButtonItem(title: "IPSendPaste".localized, style: .plain, target: self, action: #selector(handlePostPressed))

    //MARK: - Data

    var sections: [TableSection] = [
        TableSection(header: "Название", content: nil, footer: nil),
        TableSection(header: "История", content: nil, footer: "Мы оставляем за собой право переработки и правки Ваших историй с максимально возможным сохранением сюжета. Фамилии, адреса, названия компаний, вероятно, исчезнут из текста.")
    ]
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
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
        navigationItem.title = "IPAddPaste".localized
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = postButton
        extendedLayoutIncludesOpaqueBars = true
        view.addSubview(tableView)
    }
    
    private func setupTheme() {
        view.backgroundColor = theme.secondBackgroundColor
        tableView.backgroundColor = theme.secondBackgroundColor
        tableView.separatorColor = theme.separatorColor
    }
    
    @objc
    func handleCancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    func handlePostPressed() {
        
    }
}

//MARK: - ScrollView Delegate

extension AddPasteViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

//MARK: - TableView

extension AddPasteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return self.sections[section].header
        }
        return nil
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return self.sections[section].footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryView = UIInputView()
        cell.backgroundColor = theme.backgroundColor
        cell.contentView.backgroundColor = theme.backgroundColor
        cell.selectionStyle = .none
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    // Tak norm delat'
    
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
