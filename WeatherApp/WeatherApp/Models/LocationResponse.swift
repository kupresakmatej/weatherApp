//
//  LocationResponse.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import Foundation

struct LocationResponse: Codable {
    let totalResultsCount: Int
    let geonames: [Location]
}
