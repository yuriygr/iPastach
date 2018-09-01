//
//  APIManager.swift
//  iPastach
//
//  Created by Юрий Гринев on 11.03.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

struct APIResponse: Codable {
    let success: Bool?
    let error: APIResponseError?
    
    struct APIResponseError: Codable {
        let errorType, errorMessage: String?
    }
}

typealias APIParams = [String: String]

// Методы для работы с API
//  - pastes: Пасты
//  - tags: Теги
//  - pages: Страницы
enum APIMethods {
    
    case pastes(PastesEndpoint)
    enum PastesEndpoint: String {
        case add, list, item, like, complaint, random
    }
    
    case tags(TagsEndpoint)
    enum TagsEndpoint: String {
        case list
    }
    
    case pages(PagesEndpoint)
    enum PagesEndpoint: String {
        case list, item
    }
    
    var value: String {
        switch self {
        case .pastes(let value):
            return "pastes." + value.rawValue
        case .tags(let value):
            return "tags." + value.rawValue
        case .pages(let value):
            return "pages." + value.rawValue
        }
    }
}

/// API Errors
/// - invalidURL
/// - invalidParams
/// - undefined
enum APIErrors: Error {
    case invalidURL
    case invalidParams
    case undefined(error: Error)
}

class APIManager: NSObject {

    static let shared = APIManager()

    private let URLSession: URLSession = .shared
    
    private var base: String = ""
    
    private var headers: [String: String] = [:]

    /// HTTP Methods
    enum HTTPMethods: String {
        case POST
        case GET
        case PUT
        case DELETE
    }
    
    func setBase(_ base: String) {
        self.base = base
    }
    
    /// Получение данных путём POST запроса с параметрами
    ///
    /// - Parameter type: Тип возвращаемого значения
    /// - Parameter method: Метод запроса к API
    /// - Parameter params: Параметры для запроса
    /// - Parameter completion: Кложур для работы с данными
    ///
    /// - Returns: Nothing to return
    func fetch<T>(_ type: T.Type, method: APIMethods, params: APIParams = [:], HTTPMethod: HTTPMethods = .POST, completion: @escaping (T?, Error?) -> Void) where T: Decodable {
        
        guard let url = URL(string: base + method.value) else {
            return completion(nil, APIErrors.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.rawValue
        request.setBodyContent(params)
        request.setHeaders(headers)

        URLSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(nil, APIErrors.undefined(error: error))
            }
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    return completion(decoded, nil)
                } catch {
                    print(error.localizedDescription)
                    return completion(nil, APIErrors.undefined(error: error))
                }
            }
        }.resume()
    }
}
