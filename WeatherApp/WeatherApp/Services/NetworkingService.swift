//
//  NetworkingService.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import Foundation

final class NetworkingService: ObservableObject {
    static func fetchResponse<T>(of type: T.Type, with request: Request, requestBase: RequestBase) async throws -> T where T: Codable {
        guard let urlRequest = configureRequest(request, requestBase: requestBase) else {
            throw ErrorHandler.invalidURL("Invalid request path: \(request.path)")
        }
        
        guard let url = urlRequest.url else {
            throw ErrorHandler.invalidURL("Invalid URL")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ErrorHandler.responseFailed("Response received isn't a HTTPURLResponse.")
            }
            
            if httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } else {
                throw ErrorHandler(code: httpResponse.statusCode)
            }
        } catch {
            throw error
        }
    }
}

extension NetworkingService {
    static func configureRequest(_ request: Request, requestBase: RequestBase) -> URLRequest? {
        let configuration: NetworkConfiguration = NetworkConfiguration(baseURL: requestBase)
        var urlString = configuration.baseURL.rawValue + request.path

        //query
        if let query = request.query, !query.isEmpty {
            let queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
            var components = URLComponents(string: urlString)
            components?.queryItems = queryItems
            urlString = components?.url?.absoluteString ?? urlString
        }

        guard let url = URL(string: urlString) else {
            print("Error creating request URL with: \(urlString)")
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue(request.type.rawValue, forHTTPHeaderField: "Content-Type")
        
        //headers
        if let headers = configuration.staticHeaders {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        //auth headers
        if let authorization = configuration.authorizationHeaders {
            for (key, value) in authorization {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        //parameters
        if let parameters = request.parameters {
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
                urlRequest.httpBody = jsonData
            }
        }
        
        return urlRequest
    }
}

