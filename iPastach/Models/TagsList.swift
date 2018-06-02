//
//  TagsList.swift
//  iPastach
//
//  Created by Юрий Гринев on 07.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

typealias TagsList = [TagElement]

struct TagElement: Codable {
    let id: Int
    let slug: String
    let title: String
}

extension Array where Element == TagsList.Element {
    func asString() -> String {
        return self.map({"\($0.title)"}).joined(separator: ", ")
    }
}
