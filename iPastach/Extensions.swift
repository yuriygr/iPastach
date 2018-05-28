//
//  Extensions.swift
//  iPastach
//
//  Created by Юрий Гринев on 27.03.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

extension URLRequest {
    
    /// Populate the HTTPBody of `application/x-www-form-urlencoded` request
    ///
    /// - Parameter parameters:   A dictionary of keys and values to be added to the request
    mutating func setBodyContent(_ parameters: [String : String]) {
        let parameterArray = parameters.map { (key, value) -> String in
            let encodedKey   = key.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)!
            let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)!
            return "\(encodedKey)=\(encodedValue)"
        }
        httpBody = parameterArray
            .joined(separator: "&")
            .data(using: .utf8)
    }
}

extension CharacterSet {
    
    /// Character set containing characters allowed in query value as outlined in RFC 3986.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    ///
    /// - Parameter string: The string to be percent-escaped.
    ///
    /// - Returns: The percent-escaped string.
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
        
        return allowed
    }()
}

extension String {
    var utfData: Data? {
        return self.data(using: .utf8)
    }
    var attributedHtmlString: NSAttributedString? {
        guard let data = self.utfData else {
            return nil
        }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            print(error.localizedDescription)
            return nil
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

extension UITextView {
    func setHtmlText(_ html: String) {
        if let attributedText = html.attributedHtmlString {
            self.attributedText = attributedText
        }
    }
}

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func downloadFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        // Setup content mode
        contentMode = mode
        
        // Check for caching
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = imageFromCache
            return
        }
        
        // Fetch if needed
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            // Caching image
            imageCache.setObject(image, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadFrom(url: url, contentMode: mode)
    }
}

extension UIImage {
    func resize(to: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = to.width  / self.size.width
        let heightRatio = to.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func color(to: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        to.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIButton {
    // Очень грустный костыль, да
    func makeDisabled(_ disabled: Bool) {
        self.isEnabled = disabled
        self.setTitleColor(disabled ? .mainGrey : .mainBlue, for: .normal)
    }
}

extension UIColor {
    static let mainBackground = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let mainText = #colorLiteral(red: 0.1803921569, green: 0.2392156863, blue: 0.2823529412, alpha: 1)
    static let mainGrey = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)

    static let mainRed = #colorLiteral(red: 0.8509803922, green: 0.3254901961, blue: 0.3098039216, alpha: 1)
    static let mainGreen = #colorLiteral(red: 0.2509803922, green: 0.5921568627, blue: 0.2117647059, alpha: 1)
    static let mainBlue = #colorLiteral(red: 0.1098039216, green: 0.6078431373, blue: 0.7725490196, alpha: 1)
    
    static let selectedRow = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
}
