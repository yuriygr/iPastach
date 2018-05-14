//
//  ApiManager.swift
//  iPastach
//
//  Created by Юрий Гринев on 11.03.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class ApiManager: NSObject {
    
    static let shared: ApiManager = ApiManager()

    // Ещё немного чего-то крутого и потрясного
    private let URLSession: URLSession = .shared
    
    /// Base path to API
    private let path: String = "https://api.pastach.ru/"
    
    /// Methods for API request
    ///
    /// - Pastes: List of pastes
    /// - Paste: Data of paste
    /// - Tags: List of tags
    /// - Pages: List of pages
    /// - Page: Data of page
    enum methods: String {
        case pastes
        case paste
        case tags
        case pages
        case page
    }
    
    /// Possible errors
    ///
    /// - invalidURL
    /// - invalidParams
    /// - undefined
    enum Errors: Error {
        case invalidURL
        case invalidParams
        case undefined
    }
    
    /// Получение данных путём POST запроса с параметрами
    ///
    /// - Parameter type: Тип возвращаемого значения
    /// - Parameter method: Метод запроса к API
    /// - Parameter params: Параметры для запроса
    /// - Parameter completion: Кложур для работы с данными
    ///
    /// - Returns: Nothing to return
    func fetch<T>(_ type: T.Type, method: methods, params: [String:String] = [:], completion: @escaping (T?, Error?) -> Void) where T: Decodable {

        guard let url = URL(string: self.path + method.rawValue) else {
            return completion(nil, Errors.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setBodyContent(params)
        request.setValue("x-session", forHTTPHeaderField: "Sup")

        URLSession.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return completion(nil, Errors.undefined)
            }
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let decoded = try? decoder.decode(T.self, from: data)
                return completion(decoded, nil)
            }
        }.resume()
    }
    
    func pastes<T>(_ type: T.Type, completion: @escaping (T?, Error?) -> Void) where T: Decodable {
        self.fetch(type, method: .pastes, completion: completion)
    }
}

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
