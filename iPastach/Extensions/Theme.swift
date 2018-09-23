//
//  Theme.swift
//  iPastach
//
//  Created by Юрий Гринев on 04.08.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

extension Theme {
    
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
        
        navigationBarColor: .mainBackground,
        
        backgroundColor: .mainBackground,
        secondBackgroundColor: .mainSecondBackground,
        
        textColor: .mainText,
        secondTextColor: .mainGrey,
        
        tintColor: .mainTint,
        secondTintColor: .mainSecondTint,
        
        selectColor: .mainSelectColor,
        separatorColor: .mainSeparatorColor,
        shadowColor: .mainShadowColor
    )
    
    static let darkmode = Theme(
        identifier: "Darkmode",
        statusBarStyle: .lightContent,
        barStyle: .black,
        
        navigationBarColor: .darkBackground,
        
        backgroundColor: #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1),
        secondBackgroundColor: .darkSecondBackground,
        
        textColor: .darkText,
        secondTextColor: .darkGrey,
        
        tintColor: .darkTint,
        secondTintColor: .darkSecondTint,
        
        selectColor: .darkSelectColor,
        separatorColor: .darkSeparatorColor,
        shadowColor: .darkShadowColor
    )
}

extension UIColor {
    
    static let mainNavigationBarColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let mainBackground = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let mainSecondBackground = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    static let mainText = #colorLiteral(red: 0.1803921569, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
    public static let mainSelectColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    static let mainSeparatorColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    static let mainShadowColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    static let mainGrey = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    static let mainTint = #colorLiteral(red: 0.1098039216, green: 0.6078431373, blue: 0.7725490196, alpha: 1)
    static let mainSecondTint = #colorLiteral(red: 0.01960784314, green: 0.3921568627, blue: 0.5843137255, alpha: 1)
    
    static let mainRed = #colorLiteral(red: 0.8509803922, green: 0.3254901961, blue: 0.3098039216, alpha: 1)
    static let mainGreen = #colorLiteral(red: 0.2509803922, green: 0.5921568627, blue: 0.2117647059, alpha: 1)
    
    static let darkBackground = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
    static let darkSecondBackground = #colorLiteral(red: 0.0862745098, green: 0.0862745098, blue: 0.0862745098, alpha: 1)
    static let darkText = #colorLiteral(red: 1, green: 0.9882352941, blue: 0.9176470588, alpha: 1)
    public static let darkSelectColor = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
    static let darkSeparatorColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    static let darkShadowColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
    static let darkGrey = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    static let darkTint = #colorLiteral(red: 1, green: 0.9882352941, blue: 0.9286062602, alpha: 1)
    static let darkSecondTint = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
}
