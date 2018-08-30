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
    
    let navigationBarColor: UIColor

    let backgroundColor: UIColor
    let secondBackgroundColor: UIColor
    
    let textColor: UIColor
    let secondTextColor: UIColor
    
    let tintColor: UIColor
    let secondTintColor: UIColor
    
    let selectColor: UIColor
    let separatorColor: UIColor
    let shadowColor: UIColor
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
        let titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: theme.textColor
        ]
        
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().shadowImage = theme.shadowColor.as1ptImage()
        UINavigationBar.appearance().setBackgroundImage(theme.navigationBarColor.as1ptImage(), for: .default)
        UINavigationBar.appearance().barTintColor = theme.navigationBarColor
        UINavigationBar.appearance().tintColor = theme.textColor
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = titleTextAttributes
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
