//
//  PasteShortCell.swift
//  iPastach
//
//  Created by Юрий Гринев on 12.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class PasteShortCell: UITableViewCell {

    //MARK: - Properties
    fileprivate lazy var titleLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 18)
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
    
    fileprivate lazy var descriptionLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = theme.textColor
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    fileprivate lazy var readmoreLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = theme.tintColor
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.text = "IPReadmore".translated(with: "Кнопка читать далее")
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
        self.backgroundColor = theme.backgroundColor
        contentView.backgroundColor = theme.backgroundColor

        contentView.addSubview(titleLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(tagsLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(readmoreLabel)
        
        var constraints = [NSLayoutConstraint]()
        
        let viewsDict = [
            "titleLabel" : titleLabel,
            "idLabel": idLabel,
            "timeLabel": timeLabel,
            "tagsLabel": tagsLabel,
            "descriptionLabel" : descriptionLabel,
            "readmoreLabel": readmoreLabel
            ] as [String : UIView]
        
        let metricsDict = [
            "padding": 16
        ]
        
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-padding-[titleLabel]-[timeLabel]-[descriptionLabel]-[readmoreLabel]-padding-|",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-padding-[titleLabel]-[idLabel]-[descriptionLabel]-[readmoreLabel]-|",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-padding-[titleLabel]-[tagsLabel]-[descriptionLabel]-[readmoreLabel]-padding-|",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[titleLabel]-|",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[idLabel]-[timeLabel]-[tagsLabel]",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[descriptionLabel]-|",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[readmoreLabel]-|",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with paste: PasteElement) {
        titleLabel.text = paste.title
        idLabel.text = "#\(paste.id)"
        timeLabel.text = paste.formatedTime()
        descriptionLabel.text = paste.description
        
        if paste.tags.count > 0 {
            tagsLabel.text = paste.tags.asString()
        } else {
            tagsLabel.text = nil
        }
    }
}
