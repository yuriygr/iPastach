//
//  ToolbarItemsFactory.swift
//  iPastach
//
//  Created by Юрий Гринев on 24.08.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

enum ToolbarItem: Int {
    case none, like, favorites, random, copy, report
}

class ToolbarItemsFactory: NSObject {
    private let items: [ToolbarItem]
    
    private static let icons: [ToolbarItem: UIImage] = [
        .like: #imageLiteral(resourceName: "b_like"),
        .favorites: #imageLiteral(resourceName: "b_favorites"),
        .random: #imageLiteral(resourceName: "b_random"),
        .copy: #imageLiteral(resourceName: "b_copy"),
        .report: #imageLiteral(resourceName: "b_attention")
    ]
    
    private var barItems: [ToolbarItem: UIBarButtonItem] = [:]
    
    weak var delegate: ToolbarItemsFactoryDelegate?
    
    init(items: [ToolbarItem]) {
        self.items = items
    }
    
    func makeBarItems() -> [UIBarButtonItem] {
        var result = [UIBarButtonItem]()
        for (index, item) in items.enumerated() {
            let barItem = createBarItem(for: item)
            barItems[item] = barItem
            result.append(barItem)

            if index != items.count - 1 {
                result.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            }
        }
        
        return result
    }
    
    private func createBarItem(for item: ToolbarItem) -> UIBarButtonItem {
        let icon = ToolbarItemsFactory.icons[item]
        return UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(self.barItemTapped(_:)))
    }
    
    @objc
    func barItemTapped(_ barItem: UIBarButtonItem) {
        var item = ToolbarItem.none
        
        for (key, value) in barItems {
            if value == barItem {
                item = key
            }
        }
        
        delegate?.itemTapped(self, item: item, barItem: barItem)
    }
    
    func getBarItem(for item: ToolbarItem) -> UIBarButtonItem? {
        return barItems[item]
    }
}

protocol ToolbarItemsFactoryDelegate: class {
    func itemTapped(_ sender: ToolbarItemsFactory, item: ToolbarItem, barItem: UIBarButtonItem)
}
