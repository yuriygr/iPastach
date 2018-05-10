//
//  PastesList.swift
//  iPastach
//
//  Created by Юрий Гринев on 10.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

typealias PastesList = [PasteElement]

struct PasteElement: Codable {
    let id: Int
    let slug: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case title
    }
    
    init(id: Int, slug: String, title: String) {
        self.id = id
        self.slug = slug
        self.title = title
    }
}
