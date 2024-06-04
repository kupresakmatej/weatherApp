//
//  SearchListItemView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import SwiftUI

struct SearchListItemView: View {
    @Environment(\.dismiss) var dismiss
    
    let cityName: String
    let getWeatherInformation: () -> Void
    let saveSearchedCity: () -> Void
    
    init(getWeatherInformation: @escaping () -> Void, saveSearchedCity: @escaping () -> Void, cityName: String) {
        self.getWeatherInformation = getWeatherInformation
        self.cityName = cityName
        self.saveSearchedCity = saveSearchedCity
    }
    
    var body: some View {
        HStack {
            Button {
                getWeatherInformation()
                saveSearchedCity()
                dismiss()
            } label: {
                Text("\(cityName)")
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 2)
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08)
                            .background(Color.white.opacity(0.2).clipShape(RoundedRectangle(cornerRadius: 25)))                    
                    )
            }
            .buttonStyle(.plain)
        }
    }
}
