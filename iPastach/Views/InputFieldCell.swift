//
//  InputFieldCell.swift
//  iPastach
//
//  Created by Юрий Гринев on 02.09.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class InputFieldCell: UITableViewCell {

    lazy var theme: Theme = UserSettings.shared.currentTheme  
    
    lazy var textField: UITextField = {
        let textField = UITextField(frame: self.contentView.bounds)
        return textField
    }()
    
    weak var delegate: InputFieldCellDelegate?
    
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
        contentView.addSubview(textField)
        
        textField.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configure(placeholder: String) {
        textField.placeholder = placeholder
        textField.keyboardAppearance = UserSettings.shared.currentTheme == .darkmode ? .dark : .light
    }
    
    func setupTheme() {
        backgroundColor = theme.backgroundColor
        contentView.backgroundColor = theme.backgroundColor
        textField.backgroundColor = theme.backgroundColor
        textField.textColor = theme.textColor
    }
    
    //MARK: - Actions

    @objc
    private func switchChanged(_ sender: UITextField) {
        delegate?.switchChanged(sender)
    }
}

protocol InputFieldCellDelegate: class {
    
    func switchChanged(_ sender: UITextField)
}
