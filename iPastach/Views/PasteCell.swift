//
//  PasteCell.swift
//  iPastach
//
//  Created by Юрий Гринев on 12.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class PasteCell: UITableViewCell {
    
    //MARK: - Properties
    lazy var titleLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textColor = .mainText
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    lazy var idLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .mainBlue
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    lazy var timeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .mainGrey
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    lazy var descriptionLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .mainText
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    //MARK: - Life Cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Setup cell
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
        contentView.addSubview(descriptionLabel)
        
        var constraints = [NSLayoutConstraint]()
        
        let viewsDict = [
            "titleLabel" : titleLabel,
            "idLabel": idLabel,
            "timeLabel": timeLabel,
            "descriptionLabel" : descriptionLabel
            ] as [String : Any]
        
        let metricsDict = [
            "padding": 10
        ]
        
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[titleLabel]-[timeLabel]-[descriptionLabel]-|",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[titleLabel]-[idLabel]-[descriptionLabel]-|",
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
            withVisualFormat: "H:|-[idLabel]-[timeLabel]",
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
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with paste: PasteElement) {
        titleLabel.text = paste.title
        idLabel.text = "#\(paste.id)"
        timeLabel.text = paste.time
        descriptionLabel.text = paste.description
    }
}
