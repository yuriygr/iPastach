//
//  PasteShortTableViewCell.swift
//  iPastach
//
//  Created by Юрий Гринев on 12.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit
import YGKit

class PasteShortTableViewCell: UITableViewCell, PasteTableViewCellProtocol {

    //MARK: - Properties

    private var titleLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 19)
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
    
    private var descriptionLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private var readmoreLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.text = "IPReadmore".localized
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    

    //MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Конфигурация ячейки

    func setupCell() {
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
            withVisualFormat: "V:|-padding-[titleLabel]-[idLabel]-[descriptionLabel]-[readmoreLabel]-padding-|",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-padding-[titleLabel]-[timeLabel]-[descriptionLabel]-[readmoreLabel]-padding-|",
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
    
    func bind(with paste: Paste) {
        titleLabel.text = paste.title
        idLabel.text = "#\(paste.id)"
        timeLabel.text = paste.time.asString(format: "IPDateformat".localized)
        tagsLabel.text = paste.tags.count > 0 ? paste.tags.asString() : nil
        descriptionLabel.text = paste.description
    }
    
    func setup(theme: Theme) {
        backgroundColor = theme.backgroundColor
        contentView.backgroundColor = theme.backgroundColor
        customSelectColor(theme.selectColor)
        titleLabel.textColor = theme.textColor
        idLabel.textColor = theme.tintColor
        timeLabel.textColor = theme.secondTextColor
        tagsLabel.textColor = theme.tintColor
        descriptionLabel.textColor = theme.textColor
        readmoreLabel.textColor = theme.tintColor
    }
}
