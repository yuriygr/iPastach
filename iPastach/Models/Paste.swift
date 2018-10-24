//
//  Paste.swift
//  iPastach
//
//  Created by Юрий Гринев on 10.05.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

struct Paste: Codable {
    let id: Int
    let title: String
    let time: Double
    let description: String
    let content: String?
    let closed: Bool
    let nsfw: Bool
    let views: Int
    let tags: [Tag]
    let link: String

    var url: URL? {
        return URL(string: link)
    }
}
