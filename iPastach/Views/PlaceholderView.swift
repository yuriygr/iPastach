//
//  UIView.swift
//  iPastach
//
//  Created by Юрий Гринев on 11.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

//
// Если будет использоваться в tableView в качестве backgroundView - ничего делать не надо
// Если будет использоваться в качестве заглушки - надо инициализировать с фреймом
//
class PlaceholderView: TableViewBackgroundView {

    //MARK: - Properties
    var image: UIImage? {
        didSet {
            self.imageView.image = image?.resize(to: CGSize(width: 100, height: 100))
        }
    }
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    var message: String? {
        didSet {
            self.messageLabel.text = message
        }
    }

    var imageView: UIImageView = {
        $0.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    var titleLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textColor = .mainText
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    var messageLabel: UILabel = {
        $0.textColor = .mainGrey
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    //MARK: - Конфигурация View
    func setupView() {
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(messageLabel)
        
        self.imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: -10).isActive = true
        
        self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true

        self.messageLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        self.messageLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.messageLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
    }
}
