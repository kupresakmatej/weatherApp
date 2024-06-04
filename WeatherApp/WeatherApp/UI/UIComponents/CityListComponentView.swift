//
//  CityListComponentView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

struct CityListComponentView: View {
    let cityName: String
    let removeLocationFromList: () -> Void
    let navigateToHome: () -> Void
    
    var body: some View {
        ZStack {
            Button {
                navigateToHome()
            } label: {
                HStack {
                    Spacer()
                    
                    Button {
                        removeLocationFromList()
                    } label: {
                        RemoveListItemView()
                    }
                    
                    Text("\(cityName)")
                        .font(.title)
                        .padding(.trailing)
                    
                    Spacer()
                }
                .overlay (
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.black, lineWidth: 2)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                        .frame(height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.white.opacity(0.2).clipShape(RoundedRectangle(cornerRadius: 25)))
                        .allowsHitTesting(false)
                )
            }
            .buttonStyle(.plain)
        }
    }
}
