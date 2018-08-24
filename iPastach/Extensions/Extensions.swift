//
//  Extensions.swift
//  iPastach
//
//  Created by Юрий Гринев on 27.03.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

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
     let cell = tableView.dequeueCell(CustomCell)
     ```
     */
    public func dequeueCell<T: UITableViewCell>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self)) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? T else {
            fatalError("Unknown cell type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
        }
        return cell
    }
    
    public func reload() {
        self.reloadData()
        self.layoutIfNeeded()
        self.setContentOffset(self.contentOffset, animated: false)
    }
    
    public func reload(section: Int, with: UITableViewRowAnimation) {
        UIView.performWithoutAnimation {
            self.reloadSections(IndexSet(integer: section), with: with)
        }
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
    static let onThemeChanging = Notification.Name("onThemeChanging")
}
