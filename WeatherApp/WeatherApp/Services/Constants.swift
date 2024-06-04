//
//  Constants.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 09.05.2024..
//

import Foundation
import SwiftUI

struct Constants {
    static let settings = Settings(isHumidityShown: true, isPressureShown: true, isWindShown: true, isMetric: true, locations: "")
    
    static let location = Location(name: "Osijek", lng: "18.69389", lat: "45.55111")
    
    static let defaultBackground = "body_image-clear-day"
    static let defaultHeader = "header_image-clear-day"
    
    static let mphMultiplier = 0.621371
    
    static let kelvinSubtractor = 273.15
}

