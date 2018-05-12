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
    let title: String
    let time: String
    let description: String
    let nsfw: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case time
        case description
        case nsfw
    }
    
    init(id: Int, title: String, time: String, description: String, nsfw: Bool) {
        self.id = id
        self.title = title
        self.time = time
        self.description = description
        self.nsfw = nsfw
    }
}
