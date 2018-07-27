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
    let content: String?
    let closed: Bool
    let nsfw: Bool
    let views: Int
    let tags: TagsList
    let url: String?

    func formatedTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy в HH:mm"
        let dateFromTimestamp = Date(timeIntervalSince1970: self.time)
        
        return dateFormatter.string(from: dateFromTimestamp)
    }
}

struct PastesListPaginated: Codable {
    var items: PastesList?
    var first, before, current, last: Int?
    var next, total_pages, total_items: Int?
    var limit: String?
}
