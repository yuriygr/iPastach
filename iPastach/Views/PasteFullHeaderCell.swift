//
//  PasteFullHeaderCell.swift
//  iPastach
//
//  Created by Юрий Гринев on 31.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class PasteFullHeaderCell: UITableViewCell {

    lazy var theme: Theme = UserSettings.shared.currentTheme
    
    //MARK: - Properties

    private var titleLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 22)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    private var idLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    private var timeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private var tagsLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    //MARK: - Life Cycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Конфигурация ячейки

    private func setupCell() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(tagsLabel)
        
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true

        idLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        idLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        idLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    
        timeLabel.leftAnchor.constraint(equalTo: idLabel.rightAnchor, constant: 8).isActive = true
        timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        tagsLabel.leftAnchor.constraint(equalTo: timeLabel.rightAnchor, constant: 8).isActive = true
        tagsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        tagsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    func bind(data paste: Paste) {
        titleLabel.text = paste.title
        idLabel.text = "#\(paste.id)"
        timeLabel.text = paste.formatedTime()
        tagsLabel.text = paste.tags.count > 0 ? paste.tags.asString() : nil
    }
    
    func setupTheme() {
        backgroundColor = theme.backgroundColor
        contentView.backgroundColor = theme.backgroundColor
        customSelectColor(theme.selectColor)
        titleLabel.textColor = theme.textColor
        idLabel.textColor = theme.tintColor
        timeLabel.textColor = theme.secondTextColor
        tagsLabel.textColor = theme.tintColor
    }
}
