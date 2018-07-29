//
//  UIImageView.swift
//  iPastach
//
//  Created by Юрий Гринев on 27.03.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

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
