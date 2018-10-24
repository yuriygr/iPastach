//
//  Protocols.swift
//  iPastach
//
//  Created by Юрий Гринев on 21.10.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import Foundation

protocol PasteTableViewCellProtocol {
    func setupCell()
    func bind(with data: Paste)
    func setup(theme: Theme)
}
