//
//  DataController.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 19.04.2024..
//

import Foundation
import CoreData

class DataController: ObservableObject {
    private let container: NSPersistentContainer
    private let containerName: String = "WeatherApp"
    private let entityName: String = "UserSettings"
    
    @Published var settings: Settings?
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            } else {
                self.settings = self.fetchSettings()
            }
        }
    }
    
    func updateSettings(with newSettings: Settings) {
        do {
            let userSettings = try fetchOrCreateUserSettings()
            userSettings.isHumidityShown = newSettings.isHumidityShown
            userSettings.isPressureShown = newSettings.isPressureShown
            userSettings.isWindShown = newSettings.isWindShown
            userSettings.isMetric = newSettings.isMetric
            userSettings.locations = newSettings.locations
            save()
            self.settings = newSettings
        } catch {
            print("Error occurred: \(error)")
        }
    }
    
    func deleteSettings() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let results = try container.viewContext.fetch(request)
            for object in results {
                guard let objectData = object as? NSManagedObject else { continue }
                container.viewContext.delete(objectData)
            }
            save()
            self.settings = Settings(isHumidityShown: true, isPressureShown: true, isWindShown: true, isMetric: true, locations: "")
        } catch {
            print("Error fetching settings to delete: \(error)")
        }
    }

    private func fetchUserSettings() throws -> UserSettings? {
        let request = NSFetchRequest<NSManagedObject>(entityName: self.entityName)
        
        do {
            let settings = try container.viewContext.fetch(request)
            if let existingSettings = settings.first as? UserSettings {
                return existingSettings
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    private func createDefaultUserSettings() throws -> UserSettings {
        let newSettings = UserSettings(context: container.viewContext)
        try container.viewContext.save()
        return newSettings
    }
    
    private func transformManagedObjectToUserSettings(_ managedObject: NSManagedObject) throws -> UserSettings {
        guard let userSettings = managedObject as? UserSettings else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to transform NSManagedObject to UserSettings"])
        }
        return userSettings
    }
    
    func fetchOrCreateUserSettings() throws -> UserSettings {
        if let existingSettings = try fetchUserSettings() {
            return try transformManagedObjectToUserSettings(existingSettings)
        }
        
        return try createDefaultUserSettings()
    }

    private func addDefaultUserSettings() -> UserSettings {
        let newSettings = UserSettings(context: container.viewContext)
        newSettings.isHumidityShown = true
        newSettings.isPressureShown = true
        newSettings.isWindShown = true
        newSettings.isMetric = true
        save()
        return newSettings
    }
    
    func fetchSettings() -> Settings? {
        var userSettings = UserSettings()
        do {
            userSettings = try fetchOrCreateUserSettings()
        } catch {
            print("Error fetching settings: \(error)")
        }
        
        return Settings(
            isHumidityShown: userSettings.isHumidityShown,
            isPressureShown: userSettings.isPressureShown,
            isWindShown: userSettings.isWindShown,
            isMetric: userSettings.isMetric,
            locations: userSettings.locations ?? ""
        )
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving to Core Data: \(error)")
        }
    }
}

