//
//  HomeView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @Binding var isLoggedIn: Bool
    
    init(isLoggedIn: Binding<Bool>) {
        let weatherRepository = WeatherRepositoryImpl()
        let locationManager = LocationManager()
        let dataController = DataController()
        let persistenceService = CoreDataPersistenceService(dataController: dataController)
        let persistenceRepository = WeatherPersistenceRepository(persistence: persistenceService)
        
        let viewModel = HomeViewModel(weatherRepository: weatherRepository, locationManager: locationManager, persistenceRepository: persistenceRepository)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        _isLoggedIn = isLoggedIn
    }
    
    var body: some View {
        NavigationView {
            if viewModel.hasLoadingFailed {
                WeatherErrorView(backgroundImage: viewModel.decideBackground(), headerImage: viewModel.decideHeader(), errorImage: "thermometer.medium.slash", errorTitle: "Weather fetch failed", errorDescription: "Weather couldn't be fetched - \(viewModel.errorMessage!)", buttonText: "Retry", buttonAction: viewModel.prepareView)
            } else {
                ZStack {
                    BackgroundView(backgroundImage: viewModel.fullScreenCoverImage, headerImage: viewModel.headerOfCoverImage)
                        .opacity(0.8)
                    
                    VStack {
                        HStack {
                            Text("Welcome back, \(viewModel.userName)")
                                .font(.title2)
                                .padding(.leading)
                                .bold()
                            
                            Spacer()
                            
                            Button {
                                viewModel.logoutUser { result in
                                    switch result {
                                    case .success:
                                        isLoggedIn = false
                                    case .failure(let error):
                                        print("Failed to log out: \(error.localizedDescription)")
                                    }
                                }
                            } label: {
                                RoundedButton(width: 80, height: 36, buttonText: "Log out", buttonColor: Color.green)
                            }
                            .padding(.trailing)
                        }
                        .padding(.top)
                        
                        WeatherInformationView(viewModel: viewModel)
                        
                        Spacer()
                        
                        HomeBottomContainerView(isSearchPresented: viewModel.isSearchPresented, viewModel: viewModel)
                            .padding()
                    }
                }
            }
        }
        .showLoading(isLoading: $viewModel.isLoading, backgroundImage: viewModel.decideBackground(), headerImage: viewModel.decideHeader())
        .onAppear {
            viewModel.prepareView()
        }
    }
}
