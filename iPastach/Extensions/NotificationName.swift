//
//  NotificationName.swift
//  iPastach
//
//  Created by Юрий Гринев on 24.09.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let onSelectTag = Notification.Name("onSelectTag")
    static let onResetTag = Notification.Name("onResetTag")
    
    static let onPasteAddToFavorite = Notification.Name("onPasteAddToFavorite")
    static let onPasteRemoveFromFavorite = Notification.Name("onPasteRemoveFromFavorite")
    static let onPasteShared = Notification.Name("onPasteShared")
    static let onThemeChanging = Notification.Name("onThemeChanging")
}
