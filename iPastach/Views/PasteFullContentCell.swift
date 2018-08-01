//
//  PasteFullContentCell.swift
//  iPastach
//
//  Created by Юрий Гринев on 31.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class PasteFullContentCell: UITableViewCell {

    //MARK: - Properties
    lazy var textView: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK:  Theme
    lazy var theme: Theme = ThemeManager.shared.currentTheme

    //MARK: - Life Cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Конфигурация ячейки
    func setupCell() {
        contentView.backgroundColor = theme.backgroundColor
        contentView.addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    func configure(with paste: PasteElement) {
        if let content = paste.content {
            self.textView.setHtmlText(content)
            self.textView.font = .systemFont(ofSize: 15)
            self.textView.textColor = theme.textColor
        }
    }
}
