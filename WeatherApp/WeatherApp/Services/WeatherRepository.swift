//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import Foundation

protocol WeatherRepository {
    func getCityInfo(searchQuery: String) async throws -> LocationResponse
    
    func getWeatherInfo(latitude: Double, longitude: Double) async throws -> WeatherResponse
}

actor WeatherRepositoryImpl: WeatherRepository {
    func getCityInfo(searchQuery: String) async throws -> LocationResponse {
        try await WeatherRepositoryImpl.fetchLocationResponse(searchQuery: searchQuery)
    }
    
    func getWeatherInfo(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        try await WeatherRepositoryImpl.fetchWeatherResponse(latitude: latitude, longitude: longitude)
    }
}

extension WeatherRepositoryImpl {
    static func fetchLocationResponse(searchQuery: String) async throws -> LocationResponse {
        let request = Request(
            path: "searchJSON?",
            method: .get,
            type: .json,
            parameters: nil,
            query: ["q": searchQuery, "maxRows": "10", "username": "kupresakmatej"]
        )
        
        return try await NetworkingService.fetchResponse(of: LocationResponse.self, with: request, requestBase: .location)
    }

    static func fetchWeatherResponse(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        let request = Request(
            path: "weather?",
            method: .get,
            type: .json,
            parameters: nil,
            query: ["lat": String(latitude), "lon": String(longitude), "appid": "d77ff22feb61febf7fdc4bf7dfa79ca8"]
        )
        
        return try await NetworkingService.fetchResponse(of: WeatherResponse.self, with: request, requestBase: .weather)
    }
}
