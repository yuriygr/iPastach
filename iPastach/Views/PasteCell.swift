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
    fileprivate lazy var titleLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textColor = .mainText
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    fileprivate lazy var idLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .mainBlue
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    fileprivate lazy var timeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .mainGrey
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    fileprivate lazy var tagsLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .mainBlue
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    fileprivate lazy var descriptionLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .mainText
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    fileprivate lazy var readmoreLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .mainBlue
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.text = "Читать далее"
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
            ] as [String : Any]
        
        let metricsDict = [
            "padding": 20
        ]
        
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-padding-[titleLabel]-[timeLabel]-[descriptionLabel]-[readmoreLabel]-padding-|",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-padding-[titleLabel]-[idLabel]-[descriptionLabel]-[readmoreLabel]-padding-|",
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
            withVisualFormat: "H:|-padding-[titleLabel]-padding-|",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-padding-[idLabel]-[timeLabel]-[tagsLabel]",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-padding-[descriptionLabel]-padding-|",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-padding-[readmoreLabel]-padding-|",
            options: [],
            metrics: metricsDict,
            views: viewsDict
        )
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with paste: PasteElement) {
        titleLabel.text = paste.title
        idLabel.text = "#\(paste.id)"
        timeLabel.text = formatDate(with: paste.time)
        descriptionLabel.text = paste.description
        
        if paste.tags.count > 0 {
            tagsLabel.text = paste.tags.asString()
        } else {
            tagsLabel.text = nil
        }
    }
    
    //MARK: Helpers
    
    func formatDate(with timestamp: Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy в HH:mm"
        let dateFromTimestamp = Date(timeIntervalSince1970: timestamp)
        
        return dateFormatter.string(from: dateFromTimestamp)

    }
}
