//
//  SearchView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    let changeCity: (Double, Double) -> Void
    var backgroundImage: String
    var headerImage: String

    init(changeCity: @escaping (Double, Double) -> Void, backgroundImage: String, headerImage: String, persistenceRepository: PersistenceRepository) {
        let weatherRepository = WeatherRepositoryImpl()
        
        self.changeCity = changeCity
        
        _viewModel = StateObject(wrappedValue: SearchViewModel(persistenceRepository: persistenceRepository, weatherRepository: weatherRepository))
        
        self.backgroundImage = backgroundImage
        self.headerImage = headerImage
    }
    
    var body: some View {
        ZStack {
            BackgroundView(backgroundImage: backgroundImage, headerImage: headerImage)
                .blur(radius: 2)
                .opacity(0.8)
            
            VStack {
                HStack {
                    Spacer()
                    
                    ExitButtonCircleView()
                }
                
                SearchBoxView(searchText: $viewModel.searchText, hasLoadingFailed: viewModel.hasLoadingFailed)
                
                ScrollView {
                    LazyVStack(spacing: 25) {
                        ForEach(viewModel.locations) { location in
                            SearchListItemView(getWeatherInformation: {
                                changeCity(Double(location.lat) ?? 0, Double(location.lng) ?? 0)
                            }, saveSearchedCity: {
                                viewModel.saveSearchedLocation(name: location.name)
                            }, cityName: location.name)
                                .padding(.top)
                        }
                    }
                }.showLoading(isLoading: $viewModel.isLoading, backgroundImage: "", headerImage: "")
                
                Spacer()
                
                if(viewModel.hasLoadingFailed) {
                    Spacer()
                    LocationErrorToast(errorImage: "location.slash.circle", errorDescription: "Location fetch failed - \(viewModel.errorMessage!)")
                        .padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchUserSettings()
        }
    }
}
