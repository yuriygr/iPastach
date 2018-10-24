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

    private var textView: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: CGFloat(UserSettings.shared.fontSize))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Конфигурация ячейки

    func bind(data paste: Paste) {
        if let content = paste.content {
            self.textView.setHtmlText(content)
            self.textView.font = .systemFont(ofSize: CGFloat(UserSettings.shared.fontSize))
        }
    }
    
    private func setupCell() {
        contentView.addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
    func setup(theme: Theme) {
        backgroundColor = theme.backgroundColor
        contentView.backgroundColor = theme.backgroundColor
        textView.textColor = theme.textColor
        customSelectColor(theme.selectColor)
    }
}
