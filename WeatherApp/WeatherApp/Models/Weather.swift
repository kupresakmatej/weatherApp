//
//  Weather.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import Foundation

struct WeatherResponse: Identifiable, Codable {
    let id: Int
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let snow: Snow?
    let sys: Sys
    let name: String
}

enum MeasurementUnit {
    case metric
    case imperial
}

enum TemperatureType {
    case main
    case min
    case max
}

struct Snow: Codable {
    let oneHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let sunrise: TimeInterval
    let sunset: TimeInterval
}
