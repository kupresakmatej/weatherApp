//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import Foundation
import Combine
import SwiftUI

final class SearchViewModel: ObservableObject {
    private let weatherRepository: WeatherRepository
    private var searchCancellable: AnyCancellable?
    let persistenceRepository: PersistenceRepository

    init(persistenceRepository: PersistenceRepository, weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
        self.persistenceRepository = persistenceRepository
        setupSearchSubscription()
    }

    deinit {
        cancelTasks()
    }

    @Published var locations = [Location]()
    @Published var settings: Settings?
    
    @Published var isSearchPresented = false
    @Published var searchText = ""
    
    @Published var isLoading = false
    @Published var hasLoadingFailed = false
    @Published var errorMessage: String? = nil

    private var fetchingTasks = [Task<Void, Error>?]()
}

extension SearchViewModel {
    @MainActor func fetchLocationResponse(searchQuery: String) async {
        guard !isLoading else { return }

        isLoading = true
        hasLoadingFailed = false

        let fetchLocationResponseTask = Task<Void, Error> {
            do {
                let response = try await weatherRepository.getCityInfo(searchQuery: searchQuery)

                self.locations = response.geonames.map { location in
                    var locationWithUUID = location
                    locationWithUUID.id = UUID()
                    return locationWithUUID
                }

                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.hasLoadingFailed = true
                self.isLoading = false
                print("ERROR: \(error)")
            }
        }

        fetchingTasks.append(fetchLocationResponseTask)
    }
    
    private func setupSearchSubscription() {
        searchCancellable = $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.global())
            .sink { [weak self] searchText in
                if !searchText.isEmpty {
                    self?.fetchSearch()
                }
            }
    }
    
    func fetchSearch() {
        Task {
            await fetchLocationResponse(searchQuery: searchText)
        }
    }
    
    func fetchUserSettings() {
        settings = persistenceRepository.load()
    }
    
    func applyChanges() {
        if let settingsToSave = settings {
            persistenceRepository.save(settingsToSave: settingsToSave)
        }
        
        fetchUserSettings()
    }
    
    func saveSearchedLocation(name: String) {
        var newSettings = settings
        
        newSettings?.locations = appendLocations(name: name)
        settings = newSettings
        
        applyChanges()
    }
    
    func appendLocations(name: String) -> String {
        var savedLocations = settings?.locations

        if savedLocations?.count ?? 0 > 0 {
            savedLocations! += ","
        }
        
        savedLocations! += name
        
        return savedLocations ?? ""
    }

    func cancelTasks() {
        for task in fetchingTasks {
            task?.cancel()
        }
        fetchingTasks.removeAll()
        searchCancellable?.cancel()
    }
}
