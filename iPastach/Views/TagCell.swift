//
//  TagCell.swift
//  iPastach
//
//  Created by Юрий Гринев on 01.09.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {

    //MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Конфигурация ячейки

    func bind(data tag: Tag) {
        textLabel?.text = tag.title
    }
    
    func setup(theme: Theme) {
        backgroundColor = theme.backgroundColor
        contentView.backgroundColor = theme.backgroundColor
        textLabel?.textColor = theme.textColor
        customSelectColor(theme.selectColor)
    }
}
