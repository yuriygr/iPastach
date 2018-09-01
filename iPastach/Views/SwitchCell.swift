//
//  SwitchCell.swift
//  iPastach
//
//  Created by Юрий Гринев on 01.09.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {

    lazy var theme: Theme = UserSettings.shared.currentTheme  
    
    lazy var switchView: UISwitch = {
       let switchView = UISwitch(frame: .zero)
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return switchView
    }()
    
    weak var delegate: SwitchCellDelegate?
    
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
        accessoryView = switchView
        selectionStyle = .none
    }
    
    func setTitle(_ title: String) {
        textLabel?.text = title
    }
    
    func setTag(_ tag: Int) {
        switchView.tag = tag
    }

    func setState(_ value: Bool) {
        switchView.setOn(value, animated: false)
    }
    
    func setupTheme() {
        backgroundColor = theme.backgroundColor
        contentView.backgroundColor = theme.backgroundColor
        textLabel?.textColor = theme.textColor
    }
    
    //MARK: - Actions

    @objc
    private func switchChanged(_ sender: UISwitch) {
        delegate?.switchChanged(sender)
    }
}

protocol SwitchCellDelegate: class {
    
    func switchChanged(_ sender: UISwitch)
}
