//
//  BottomContainerView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

struct HomeBottomContainerView: View {
    @State var isSearchPresented: Bool
    let viewModel: HomeViewModel
    
    var body: some View {
        HStack {
            Button {
                isSearchPresented.toggle()
            } label: {
                SearchIconView(color: .black, width: 48, height: 48)
            }
            .fullScreenCover(isPresented: $isSearchPresented) {
                SearchView(changeCity: { latitude, longitude in
                    viewModel.changeCity(latitude: latitude, longitude: longitude)
                }, backgroundImage: viewModel.fullScreenCoverImage , headerImage: viewModel.headerOfCoverImage , persistenceRepository: viewModel.persistenceRepository)
            }
            
            Spacer()
            
            NavigationLink {
                SettingsView(persistenceRepository: viewModel.persistenceRepository, backgroundImage: viewModel.fullScreenCoverImage , headerImage: viewModel.headerOfCoverImage , fetchSavedLocation: { query in
                    viewModel.fetchSavedLocation(searchQuery: query)
                })
            } label: {
                SettingsIconView(color: .black)
            }
        }
    }
}
