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
    let content: String
    let nsfw: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case title
        case content
        case nsfw
    }
    
    init(id: Int, slug: String, title: String, content: String, nsfw: Bool) {
        self.id = id
        self.slug = slug
        self.title = title
        self.content = content
        self.nsfw = nsfw
    }
}
