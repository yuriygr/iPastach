//
//  Pagination.swift
//  iPastach
//
//  Created by Юрий Гринев on 29.07.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import Foundation

struct PaginationFor<T>: Codable where T: Codable {
    var items: [T]?
    var first, before, current, last: Int?
    var next, total_pages, total_items: Int?
    var limit: String?
}

struct Pagination: Codable {
    var first, before, current, last: Int?
    var next, total_pages, total_items: Int?
    var limit: String?
}
