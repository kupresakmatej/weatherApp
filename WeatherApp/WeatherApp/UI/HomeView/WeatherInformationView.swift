//
//  WeatherInformationView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 18.04.2024..
//

import SwiftUI

struct WeatherInformationView: View {
    let viewModel: HomeViewModel
    
    var body: some View {
        TemperatureDescriptionView(viewModel: viewModel)
        
        Spacer()
        
        LocationNameView(viewModel: viewModel)
        
        MinMaxTemperatureView(viewModel: viewModel)
        
        Spacer()
        
        ConditionsContainerView(viewModel: viewModel)
    }
}

struct TemperatureDescriptionView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        Text(viewModel.getTemperature(tempType: .main))
            .font(.system(size: 100))
            .padding(.top)
        
        Text("\(viewModel.currentWeather?.weather.first?.description ?? "")".capitalized)
            .font(.title)
    }
}

struct LocationNameView: View {
    let viewModel: HomeViewModel
    
    var body: some View {
        Text("\(viewModel.currentWeather?.name ?? "")")
            .font(.largeTitle)
            .bold()
    }
}

struct MinMaxTemperatureView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack {
            VStack {
                TemperatureContainerView(temperature: viewModel.getTemperature(tempType: .min), description: "Low")
            }
            .padding()
            
            Divider()
                .overlay(Color.black)
            
            VStack {
                TemperatureContainerView(temperature: viewModel.getTemperature(tempType: .max), description: "High")
            }
            .padding()
        }
        .fixedSize()
    }
}

struct TemperatureContainerView: View {
    let temperature: String
    let description: String
    
    var body: some View {
        Text(temperature)
            .font(.title2)
            .padding(.bottom, 5)
            .bold()
        
        Text("\(description)")
    }
}

struct ConditionsContainerView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack {
            if viewModel.settings.isHumidityShown {
                VStack {
                    ConditionImageView(image: "humidity_icon")
                    
                    Text("\(viewModel.currentWeather?.main.humidity ?? 0)%")
                        .font(.title2)
                }
            }
            
            if viewModel.settings.isPressureShown {
                VStack {
                    ConditionImageView(image: "pressure_icon")
                    
                    Text("\((Double(viewModel.currentWeather?.main.pressure ?? 0) / 1000), specifier: "%.3f") hPa")
                        .font(.title2)
                }
            }
            
            if viewModel.settings.isWindShown {
                VStack {
                    ConditionImageView(image: "wind_icon")
                    
                    Text(viewModel.getWindSpeed())
                        .font(.title2)
                }
            }
        }
        .onAppear {
            viewModel.fetchUserSettings()
        }
    }
}
