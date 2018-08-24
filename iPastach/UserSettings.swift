//
//  UserSettings.swift
//  iPastach
//
//  Created by Юрий Гринев on 20.08.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import Foundation

class UserSettings {

    public static let shared = UserSettings()
    
    private let defaults = UserDefaults.standard
    
    init() {
        defaults.register(defaults: [
            "TITLES_ON_TABBAR": false,
            "CURRENT_THEME": "Normal"
        ])
    }
    
    var showTitlesOnTabbar: Bool {
        get {
            return defaults.bool(forKey: "TITLES_ON_TABBAR")
        }
        set {
            defaults.set(newValue, forKey: "TITLES_ON_TABBAR")
        }
    }
    
    var currentTheme: Theme {
        get {
            return Theme.by(string: defaults.string(forKey: "CURRENT_THEME") ?? "Normal")
        }
        
        set {
            defaults.set(newValue.identifier, forKey: "CURRENT_THEME")
        }
    }
    
    var lastCacheCleanTime: Date {
        get {
            let timestamp = defaults.double(forKey: "LAST_CACHE_CLEAN_TIME")
            return Date(timeIntervalSince1970: timestamp)
        }
        
        set {
            defaults.set(newValue.timeIntervalSince1970, forKey: "LAST_CACHE_CLEAN_TIME")
        }
    }
}
