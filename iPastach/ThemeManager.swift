//
//  ThemeManager.swift
//  iPastach
//
//  Created by Юрий Гринев on 28.07.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit
import Foundation


// Themes params
struct Theme {
    let identifier: String
    let statusBarStyle: UIStatusBarStyle
    let barStyle: UIBarStyle
    let backgroundColor: UIColor
    let textColor: UIColor
    let secondTextColor: UIColor
    let tintColor: UIColor
    let secondTintColor: UIColor
    let selectColor: UIColor
    
    static func by(string: String) -> Theme {
        switch string {
        case "Normal":
            return Theme.normal
        case "Darkmode":
            return Theme.darkmode
        default:
            return Theme.normal
        }
    }
    
    static let normal = Theme(
        identifier: "Normal",
        statusBarStyle: .default,
        barStyle: .default,
        backgroundColor: .mainBackground,
        textColor: .mainText,
        secondTextColor: .mainGrey,
        tintColor: .mainTint,
        secondTintColor: .mainSecondTint,
        selectColor: .mainSelectColor
    )
    
    static let darkmode = Theme(
        identifier: "Darkmode",
        statusBarStyle: .lightContent,
        barStyle: .black,
        backgroundColor: .darkBackground,
        textColor: .darkText,
        secondTextColor: .darkGrey,
        tintColor: .darkTint,
        secondTintColor: .darkSecondTint,
        selectColor: .darkSelectColor
    )
}

let isDarkModeKey = "isDarkMode"

class ThemeManager {

    static let shared: ThemeManager = ThemeManager()
    
    var currentTheme: Theme {
        get {
            if let storedTheme = UserDefaults.standard.string(forKey: isDarkModeKey) {
                return Theme.by(string: storedTheme)
            } else {
                return .normal
            }
        }
        set {
            UserDefaults.standard.setValue(newValue.identifier, forKey: isDarkModeKey)
            UserDefaults.standard.synchronize()
            ThemeManager.shared.apply(theme: newValue)
        }
    }
    
    func apply(theme: Theme) {
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.tintColor
        sharedApplication.delegate?.window??.backgroundColor = theme.backgroundColor
        
        sharedApplication.statusBarStyle = theme.statusBarStyle
        
        // Navigation bar
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = theme.backgroundColor
        UINavigationBar.appearance().backgroundColor = theme.backgroundColor
        UINavigationBar.appearance().tintColor = theme.textColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: theme.textColor]
        
        // Navigation bar item
        UIBarButtonItem.appearance().tintColor = theme.tintColor
        
        // Tab bar
        UITabBar.appearance().barStyle = theme.barStyle // ?
        UITabBar.appearance().barTintColor = theme.backgroundColor
        UITabBar.appearance().tintColor = theme.tintColor
    }
    
    func useLargeTitles() {
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().prefersLargeTitles = true
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: currentTheme.textColor]
        }
    }
}
