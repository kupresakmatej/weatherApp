//
//  PersistenceService.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 09.05.2024..
//

import Foundation

protocol PersistenceService {
    func getSettings() -> Settings
    func setSettings(settings: Settings)
}

class CoreDataPersistenceService: PersistenceService {
    let dataController: DataController
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
    
    func getSettings() -> Settings {
        return dataController.fetchSettings() ?? Constants.settings
    }
    
    func setSettings(settings: Settings) {
        dataController.updateSettings(with: settings)
    }
}

protocol PersistenceRepository {
    func load() -> Settings
    func save(settingsToSave: Settings)
}

class WeatherPersistenceRepository: PersistenceRepository {
    private let persistence: PersistenceService
    
    init(persistence: PersistenceService) {
        self.persistence = persistence
    }
    
    func load() -> Settings {
        return persistence.getSettings()
    }
    
    func save(settingsToSave: Settings) {
        persistence.setSettings(settings: settingsToSave)
    }
}

