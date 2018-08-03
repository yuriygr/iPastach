//
//  PasteFullHeaderCell.swift
//  iPastach
//
//  Created by Юрий Гринев on 31.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class PasteFullHeaderCell: UITableViewCell {

    //MARK: - Properties
    fileprivate lazy var titleLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 22)
        $0.textColor = theme.textColor
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    fileprivate lazy var idLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = theme.tintColor
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    fileprivate lazy var timeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = theme.secondTextColor
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    fileprivate lazy var tagsLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = theme.tintColor
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

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
    
    func configure(with paste: PasteElement) {
        titleLabel.text = paste.title
        idLabel.text = "#\(paste.id)"
        timeLabel.text = paste.formatedTime()
        tagsLabel.text = paste.tags.count > 0 ? paste.tags.asString() : nil
    }
}
