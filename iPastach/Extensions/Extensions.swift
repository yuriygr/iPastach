//
//  Extensions.swift
//  iPastach
//
//  Created by Юрий Гринев on 27.03.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

extension UILabel {
    func setHtmlText(_ html: String) {
        if let attributedText = html.attributedHtmlString {
            self.attributedText = attributedText
        }
    }
}

extension UINavigationItem {
    func withoutNameBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.backBarButtonItem = backButton
    }
}

extension UIBarButtonItem {
    // Очень грустный костыль, да
    var isHidden: Bool {
        get {
            return !isEnabled && tintColor == .clear
        }
        set {
            tintColor = newValue ? .clear : nil
            isEnabled = !newValue
        }
    }
}

extension UIColor {
    
    static let mainBackground = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let mainText = #colorLiteral(red: 0.1803921569, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
    public static let mainSelectColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    static let mainGrey = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    static let mainTint = #colorLiteral(red: 0.1098039216, green: 0.6078431373, blue: 0.7725490196, alpha: 1)
    static let mainSecondTint = #colorLiteral(red: 0.01960784314, green: 0.3921568627, blue: 0.5843137255, alpha: 1)

    static let mainRed = #colorLiteral(red: 0.8509803922, green: 0.3254901961, blue: 0.3098039216, alpha: 1)
    static let mainGreen = #colorLiteral(red: 0.2509803922, green: 0.5921568627, blue: 0.2117647059, alpha: 1)
    
    static let darkBackground = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
    static let darkText = #colorLiteral(red: 1, green: 0.9882352941, blue: 0.9176470588, alpha: 1)
    public static let darkSelectColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    static let darkGrey = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    static let darkTint = #colorLiteral(red: 1, green: 0.9882352941, blue: 0.9612668505, alpha: 1)
    static let darkSecondTint = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)

    /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    ///
    /// - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}

/// https://github.com/ovenbits/Alexandria/blob/master/Sources/UITableView%2BExtensions.swift
extension UITableView {

    /**
     Registers a UITableViewCell for use in a UITableView.
 
     - parameter type: The type of cell to register.
     - parameter reuseIdentifier: The reuse identifier for the cell (optional).
 
     By default, the class name of the cell is used as the reuse identifier.
 
     Example:
     ```
     class CustomCell: UITableViewCell {}
 
     let tableView = UITableView()
 
     // registers the CustomCell class with a reuse identifier of "CustomCell"
     tableView.registerCell(CustomCell)
     ```
     */
    public func registerCell<T: UITableViewCell>(_ type: T.Type, withIdentifier reuseIdentifier: String = String(describing: T.self)) {
        register(T.self, forCellReuseIdentifier: reuseIdentifier)
    }

    /**
     Dequeues a UITableViewCell for use in a UITableView.
     
     - parameter type: The type of the cell.
     - parameter reuseIdentifier: The reuse identifier for the cell (optional).
     
     - returns: A force-casted UITableViewCell of the specified type.
     
     By default, the class name of the cell is used as the reuse identifier.
     
     Example:
     ```
     class CustomCell: UITableViewCell {}
     
     let tableView = UITableView()
     
     // dequeues a CustomCell class
     let cell = tableView.dequeueReusableCell(CustomCell)
     ```
     */
    public func dequeueCell<T: UITableViewCell>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self)) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? T else {
            fatalError("Unknown cell type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
        }
        return cell
    }
}

extension UITableViewCell {
    /// Set the color of the cell when selecting
    ///
    /// - Parameter selectColor: Color of the cell when selecting
    public func customSelectColor(_ selectColor: UIColor = .mainSelectColor) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = selectColor
        self.selectedBackgroundView = backgroundView
    }
}

extension Notification.Name {
    static let onSelectTag = Notification.Name("onSelectTag")
    static let onResetTag = Notification.Name("onResetTag")
    
    static let onPasteAddToFavorite = Notification.Name("onPasteAddToFavorite")
    static let onPasteRemoveFromFavorite = Notification.Name("onPasteRemoveFromFavorite")
    static let onPasteShared = Notification.Name("onPasteShared")
}
