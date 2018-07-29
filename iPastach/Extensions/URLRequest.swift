//
//  URLRequest.swift
//  iPastach
//
//  Created by Юрий Гринев on 27.03.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

extension URLRequest {
    
    /// Populate the HTTPBody of `application/x-www-form-urlencoded` request
    ///
    /// - Parameter parameters: A dictionary of keys and values to be added to the request
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
