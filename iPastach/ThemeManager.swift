//
//  ThemeManager.swift
//
//  Created by Юрий Гринев on 28.07.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

struct Theme {
    let identifier: String

    let statusBarStyle: UIStatusBarStyle
    let barStyle: UIBarStyle

    let backgroundColor: UIColor
    let secondBackgroundColor: UIColor
    
    let textColor: UIColor
    let secondTextColor: UIColor
    
    let tintColor: UIColor
    let secondTintColor: UIColor
    
    let selectColor: UIColor
    let separatorColor: UIColor
}

extension Theme: Equatable {
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class ThemeManager: NSObject {
    
    static let shared = ThemeManager()

    func apply(theme: Theme) {
                
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.backgroundColor = theme.backgroundColor
        sharedApplication.statusBarStyle = theme.statusBarStyle
        
        // Navigation bar
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = theme.backgroundColor
        UINavigationBar.appearance().backgroundColor = theme.backgroundColor
        UINavigationBar.appearance().tintColor = theme.textColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: theme.textColor]
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: theme.textColor]
        }
        
        // Navigation bar item
        UIBarButtonItem.appearance().tintColor = theme.tintColor
        
        // Tabbar
        UITabBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().barTintColor = theme.backgroundColor
        UITabBar.appearance().tintColor = theme.tintColor
        
        // Toolbar
        UIToolbar.appearance().barTintColor = theme.backgroundColor
        UIToolbar.appearance().backgroundColor = theme.backgroundColor
        UIToolbar.appearance().tintColor = theme.tintColor
    }
    
    func useLargeTitles() {
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().prefersLargeTitles = true
        }
    }
}
