//
//  Location.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import Foundation

struct Location: Identifiable, Codable {
    var id: UUID?
    let name: String
    let lng: String
    let lat: String
}
