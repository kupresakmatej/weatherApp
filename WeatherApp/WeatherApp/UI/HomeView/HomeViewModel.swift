//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import Foundation
import SwiftUI
import CoreLocation
import FirebaseAuth

final class HomeViewModel: ObservableObject {
    let weatherRepository: WeatherRepository
    let locationManager: LocationManager
    
    let persistenceRepository: PersistenceRepository
    
    init(weatherRepository: WeatherRepository, locationManager: LocationManager, persistenceRepository: PersistenceRepository) {
        self.weatherRepository = weatherRepository
        self.locationManager = locationManager
        self.persistenceRepository = persistenceRepository
        
        self.settings = Settings(
            isHumidityShown: true,
            isPressureShown: true,
            isWindShown: true,
            isMetric: true,
            locations: ""
        )
    }
    
    deinit {
        cancelTasks()
    }
    
    @Published var userName: String = ""
    
    @Published var currentUserLocation: CLLocation?
    @Published var locations = [Location]()
    
    @Published var currentWeather: WeatherResponse?
    
    @Published var isLoading = false
    @Published var hasLoadingFailed = false
    @Published var errorMessage: String? = nil
    @Published var isSearchPresented = false
    
    @Published var settings: Settings
    
    @Published var fullScreenCoverImage: String = ""
    @Published var headerOfCoverImage: String = ""
    
    private var fetchingTasks = [Task<Void, Error>?]()
}

extension HomeViewModel {
    func fetchLoggedInUserName() {
        if let currentUser = Auth.auth().currentUser {
            userName = currentUser.displayName ?? ""
        }
    }
    
    func logoutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            userName = ""
            completion(.success(()))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }
    
    @MainActor func fetchWeatherResponse(latitude: Double, longitude: Double) async {
        guard !isLoading else { return }
        
        isLoading = true
        
        let fetchWeatherResponseTask = Task<Void, Error> {
            do {
                let response = try await weatherRepository.getWeatherInfo(latitude: latitude, longitude: longitude)
                
                updateBackgroundImages(weatherDescription: response.weather.first?.description ?? "")
                
                fetchUserSettings()
                
                self.currentWeather = response
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.hasLoadingFailed = true
                self.isLoading = false
                print("ERROR: \(error)")
            }
        }
        
        fetchingTasks.append(fetchWeatherResponseTask)
    }
    
    @MainActor func fetchSavedLocation(searchQuery: String) {
        isLoading = true

        let fetchLocationTask = Task<Void, Error> {
            do {
                let response = try await weatherRepository.getCityInfo(searchQuery: searchQuery)
                isLoading = false

                let location = response.geonames.first ?? Constants.location
                
                changeCity(latitude: Double(location.lat) ?? 0, longitude: Double(location.lng) ?? 0)
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
                print("ERROR: \(error)")
                throw error
            }
        }
        
        fetchingTasks.append(fetchLocationTask)
    }
    
    func getCurrentLocation() {
        locationManager.getCurrentLocation { [weak self] location in
            guard let self = self else { return }
            
            self.currentUserLocation = location
            
            let latitude = self.currentUserLocation?.coordinate.latitude ?? 0
            let longitude = self.currentUserLocation?.coordinate.longitude ?? 0
            
            let fetchWeatherTask = Task<Void, Error> {
                await self.fetchWeatherResponse(latitude: latitude, longitude: longitude)
            }
            fetchingTasks.append(fetchWeatherTask)
        }
    }
    
    func prepareView() {
        hasLoadingFailed = false
        
        getCurrentLocation()
        fetchUserSettings()
        fetchLoggedInUserName()
    }
    
    func getTemperature(tempType: TemperatureType) -> String {
        switch tempType {
        case .main:
            return "\(formatMeasurementUnit(input: self.currentWeather?.main.temp ?? 0))" + "\(self.settings.isMetric ? "°C" : " K")"
        case .min:
            return "\(formatMeasurementUnit(input: self.currentWeather?.main.temp_min ?? 0))" + "\(self.settings.isMetric ? "°C" : " K")"
        case .max:
            return "\(formatMeasurementUnit(input: self.currentWeather?.main.temp_max ?? 0))" + "\(self.settings.isMetric ? "°C" : " K")"
        }
    }
    
    func getWindSpeed() -> String {
        if(settings.isMetric) {
            return "\(Int(currentWeather?.wind.speed ?? 0)) km/h"
        } else {
            let mphSpeed = (currentWeather?.wind.speed ?? 0) * Constants.mphMultiplier
            return String(format: "%.2f mph", mphSpeed)
        }
    }
    
    func formatMeasurementUnit(input: Double) -> Int {
        if(settings.isMetric) {
            return Int(input - Constants.kelvinSubtractor)
        } else {
            return Int(input)
        }
    }
    
    func changeCity(latitude: Double, longitude: Double) {
        let updateTask = Task<Void, Error> {
            await fetchWeatherResponse(latitude: latitude, longitude: longitude)
        }
        fetchingTasks.append(updateTask)
    }
    
    func cancelTasks() {
        for task in fetchingTasks {
            task?.cancel()
        }
        fetchingTasks.removeAll()
    }
    
    func fetchUserSettings() {
        DispatchQueue.main.async {
            self.settings = self.persistenceRepository.load()
        }
        objectWillChange.send()
    }
    
    func updateBackgroundImages(weatherDescription: String) {
        let imageName = backgroundImageName(for: weatherDescription)
        fullScreenCoverImage = "body_image-\(imageName)"
        headerOfCoverImage = "header_image-\(imageName)"
    }
    
    private func backgroundImageName(for description: String) -> String {
        let lowercasedDescription = description.lowercased()
        
        if lowercasedDescription.contains("clear sky") {
            return isDaytime ? "clear-day" : "clear-night"
        } else if lowercasedDescription.contains("clouds") {
            return "cloudy"
        } else if lowercasedDescription.contains("rain") {
            return "rain"
        } else if lowercasedDescription.contains("thunderstorm") {
            return "thunderstorm"
        } else if lowercasedDescription.contains("snow") {
            return "snow"
        } else if lowercasedDescription.contains("mist") || lowercasedDescription.contains("fog") {
            return "fog"
        } else {
            return "clear-day"
        }
    }
    
    private var isDaytime: Bool {
        guard let sunriseTimestamp = currentWeather?.sys.sunrise,
              let sunsetTimestamp = currentWeather?.sys.sunset else {
            return true
        }
        
        let sunriseDate = Date(timeIntervalSince1970: sunriseTimestamp)
        let sunsetDate = Date(timeIntervalSince1970: sunsetTimestamp)
        
        let now = Date()
        
        return now >= sunriseDate && now <= sunsetDate
    }
    
    func decideBackground() -> String {
        return (fullScreenCoverImage == "") ? Constants.defaultBackground : fullScreenCoverImage
    }
    
    func decideHeader() -> String {
        return (headerOfCoverImage == "") ? Constants.defaultHeader : headerOfCoverImage
    }
}
