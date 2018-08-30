//
//  PageViewController.swift
//  iPastach
//
//  Created by Юрий Гринев on 27.08.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    var api: APIManager = .shared
    var alertsHelper = AlertsHelper.shared
    var theme: Theme = UserSettings.shared.currentTheme
    
    //MARK: - Properties

    lazy var textView: UITextView = {
        let textView = UITextView(frame: self.view.bounds)
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.isEditable = false
        textView.isSelectable = true
        return textView
    }()

    lazy var shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonPressed))
    
    //MARK: - Data
    
    var page: Page?
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        api.fetch(Page.self, method: .pages(.item)) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                self.page = data
            }
            DispatchQueue.main.async {
                if let content = self.page?.title {
                    self.textView.setHtmlText(content)
                    self.textView.font = .systemFont(ofSize: 15)
                    self.textView.textColor = self.theme.textColor
                }
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
        textView.frame = view.bounds
    }

    //MARK: - Setup's

    func setupController() {
        navigationItem.title = page?.title
        navigationItem.rightBarButtonItem = shareButton
        extendedLayoutIncludesOpaqueBars = true
        view.addSubview(textView)
    }

    private func setupTheme() {
        view.backgroundColor = theme.secondBackgroundColor
        textView.backgroundColor = theme.secondBackgroundColor
        textView.textColor = theme.textColor
    }

    //MARK: - Actions

    @objc
    private func shareButtonPressed() {

    }
}
