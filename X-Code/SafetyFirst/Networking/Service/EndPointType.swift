//
//  EndPointType.swift
//  SafetyFirst
//
//  Created by Erwin Warkentin on 12.11.20.
//

import Foundation

typealias HTTPBody = Data
typealias URLParameters = [String: Any]
typealias HTTPHeaders = [String: String]

protocol EndPointType {
    associatedtype Response: Codable
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var urlParameters: URLParameters? { get }
}

extension EndPointType {
    func makeRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "\(baseURL.path)/\(path)"

        if let parameters = urlParameters {

            components.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                let query = URLQueryItem(
                    name: key,
                    value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                )

                components.queryItems?.append(query)
            }
        }

        guard let url = components.url else {
            return nil
        }

        print("request url: \n\(url)")
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        return request
    }
}
