//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    var backgroundImage: String
    var headerImage: String

    let fetchSavedLocation: (String) -> Void

    init(persistenceRepository: PersistenceRepository, backgroundImage: String, headerImage: String, fetchSavedLocation: @escaping (String) -> Void) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(persistenceRepository: persistenceRepository))
        
        self.backgroundImage = backgroundImage
        self.headerImage = headerImage
        self.fetchSavedLocation = fetchSavedLocation
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(backgroundImage: backgroundImage, headerImage: headerImage)
                    .blur(radius: 2)
                    .opacity(0.8)
                
                VStack {
                    Text("Locations")
                        .font(.title2)
                        .bold()
                        .padding(.top, 50)
                    
                    ScrollView {
                        LazyVStack(spacing: 1) {
                            ForEach(viewModel.locations, id: \.self) { location in
                                if location == "" {
                                    Text("No locations saved...")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                } else {
                                    CityListComponentView(cityName: location) {
                                        viewModel.removeLocation(locationName: location)
                                    } navigateToHome: {
                                        fetchSavedLocation(location)
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.17)
                    
                    UnitsView(viewModel: viewModel)
                    
                    ConditionsView(viewModel: viewModel)
                    
                    HStack {
                        Spacer()
                        
                        ApplyButtonView(viewModel: viewModel)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.fetchUserSettings()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButtonView()
            }
            
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Settings")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.top)
                }
            }
        }
    }
}
