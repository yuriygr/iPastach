//
//  Tag.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

struct Tag: Codable {
    let id: Int
    let slug: String
    let title: String
}

extension Array where Element == Tag {
    func asString(separator: String = ", ") -> String {
        return self.map({"\($0.title)"}).joined(separator: separator)
    }
}
