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
    let time: Double
    let description: String
    let closed: Bool
    let nsfw: Bool
    let views: Int
    let tags: TagsList
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case time
        case description
        case closed
        case nsfw
        case views
        case tags
        case url
    }
}

struct PastesListPaginated: Codable {
    let items: PastesList
    let next: Int
    let prev: Int
    let total: Int
    let current: Int
    
    enum CodingKeys: String, CodingKey {
        case items
        case next
        case prev
        case total
        case current
    }
}
