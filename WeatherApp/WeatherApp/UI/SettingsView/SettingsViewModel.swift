//
//  SettingsViewModel.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 19.04.2024..
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    let persistenceRepository: PersistenceRepository
    
    @Published var backgroundImage = "header_image-clear-day"
    @Published var headerImage = "header_image-clear-day"
    
    @Published var settings: Settings?
    @Published var locations = [String]()
    
    init(persistenceRepository: PersistenceRepository) {
        self.persistenceRepository = persistenceRepository
    }
}

extension SettingsViewModel {
    func fetchUserSettings() {
        settings = persistenceRepository.load()
        
        fetchLocations()
    }
    
    func applyChanges() {
        if let settingsToSave = settings {
            persistenceRepository.save(settingsToSave: settingsToSave)
        }
        
        fetchUserSettings()
    }
    
    func fetchLocations() {
        locations = parseSavedLocations(locations: settings?.locations ?? "")
    }
    
    func parseSavedLocations(locations: String) -> [String]{
        let convertedLocations = locations.components(separatedBy: ",")
        
        return convertedLocations
    }
    
    func removeLocation(locationName: String) {
        var newSettings = settings
        
        newSettings?.locations = removeChosenLocation(locationName: locationName).joined(separator: ",")
        settings = newSettings
        
        applyChanges()
    }
    
    func removeChosenLocation(locationName: String) -> [String] {
        if let index = locations.firstIndex(of: locationName) {
            locations.remove(at: index)
        }
        return locations
    }
    
    @MainActor func toggleHumidity() {
        var newSettings = settings
        newSettings?.isHumidityShown.toggle()
        settings = newSettings
    }
    
    @MainActor func togglePressure() {
        var newSettings = settings
        newSettings?.isPressureShown.toggle()
        settings = newSettings
    }
    
    @MainActor func toggleWind() {
        var newSettings = settings
        newSettings?.isWindShown.toggle()
        settings = newSettings
    }
    
    @MainActor func toggleMetric() {
        var newSettings = settings
        var newMetric = newSettings?.isMetric
        newMetric?.toggle()
        settings?.isMetric = newMetric ?? true
    }
}

