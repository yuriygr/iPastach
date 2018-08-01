//
//  APIManager.swift
//  iPastach
//
//  Created by Юрий Гринев on 11.03.2018.
//  Copyright © 2018 Юрий Гринев. All rights reserved.
//

import UIKit

class APIManager: NSObject {
      
    static let shared: APIManager = APIManager()

    // Ещё немного чего-то крутого и потрясного
    private let URLSession: URLSession = .shared
    
    /// Base path to API
    private let APIBase: String = "https://api.pastach.ru/"
    
    // Endpoints
    enum APIEndpoints {
        enum pastes: String {
            case add = "pastes.add"
            case list = "pastes.list"
            case item = "pastes.item"
            case report = "pastes.report"
        }
        enum tags: String {
            case list = "tags.list"
        }
    }
    
    // Алиас для параметров
    typealias APIParams = [String: String]
    
    /// HTTP Methods
    enum HTTPMethods: String {
        case POST
        case GET
        case PUT
        case DELETE
    }

    /// Errors
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
    private func fetch<T>(_ type: T.Type, endpoint: String, params: APIParams = [:], method: HTTPMethods = .POST, completion: @escaping (T?, Error?) -> Void) where T: Decodable {

        guard let url = URL(string: APIBase + endpoint) else {
            return completion(nil, Errors.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setBodyContent(params)

        URLSession.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return completion(nil, Errors.undefined)
            }
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    return completion(decoded, nil)
                } catch {
                    print(error)
                    return completion(nil, Errors.undefined)
                }
            }
        }.resume()
    }

    //MARK: - Временные постоянные решения
    func pastes<T>(_ type: T.Type, endpoint: APIEndpoints.pastes, params: APIParams = [:], completion: @escaping (T?, Error?) -> Void) where T: Decodable {
        fetch(type, endpoint: endpoint.rawValue, params: params, completion: completion)
    }

    func tags<T>(_ type: T.Type, endpoint: APIEndpoints.tags, params: APIParams = [:], completion: @escaping (T?, Error?) -> Void) where T: Decodable {
        fetch(type, endpoint: endpoint.rawValue, params: params, completion: completion)
    }
}
