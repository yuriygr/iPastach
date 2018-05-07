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
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
    }
    
    init(id: Int, slug: String, name: String) {
        self.id = id
        self.slug = slug
        self.name = name
    }
}
