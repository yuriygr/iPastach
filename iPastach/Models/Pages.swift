//
//  Pages.swift
//  iPastach
//
//  Created by Юрий Гринев on 21.08.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

struct Page: Codable {
    let id: Int
    let slug: String
    let title: String
    let content: String?
    let time: Double
    let link: String
    
    var url: URL? {
        return URL(string: link)
    }
}
