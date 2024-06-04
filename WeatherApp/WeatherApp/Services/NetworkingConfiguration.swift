//
//  NetworkingConfiguration.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//
import Foundation

struct NetworkConfiguration {
    let baseURL: RequestBase
    let staticHeaders: [String: String]? = nil
    let authorizationHeaders: [String: String]? = nil
}

enum HTTPMethod: String {
    case get = "get"
}

enum RequestType: String {
    case json = "Application/json; charset=utf-8"
    case query = "Application/w-xxx-form-urlencoded; charset=utf-8"
}

enum RequestBase: String {
    case location = "http://api.geonames.org/"
    case weather = "https://api.openweathermap.org/data/2.5/"
}

struct Request {
    let path: String
    let method: HTTPMethod
    let type: RequestType
    let parameters: [String: Any]?
    let query: [String: String]?
}

enum ErrorHandler: Error {
    case cannotParse
    case configFailed(String)
    case invalidURL(String)
    case responseFailed(String)
    case notFound
    case other(Int)
    
    init(code: Int) {
        switch code {
        case 404: self = .notFound
        default: self = .other(code)
        }
    }
}
