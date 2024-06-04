//
//  WeatherErrorView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 20.05.2024..
//

import SwiftUI

struct WeatherErrorView: View {
    @Environment(\.dismiss) var dismiss
    
    let backgroundImage: String
    let headerImage: String
    
    let errorImage: String
    let errorTitle: String
    let errorDescription: String
    let buttonText: String
    let buttonAction: () -> ()
    
    var body: some View {
        ZStack {
            BackgroundView(backgroundImage: backgroundImage, headerImage: headerImage)
                .blur(radius: 8)
                .opacity(0.8)
            
            VStack {
                Image(systemName: errorImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                    .padding(.bottom)
                
                HStack {
                    Text(errorTitle)
                        .font(.title)
                        .bold()
                }
                .padding(.bottom)
                
                Text(errorDescription)
                    .font(.title2)
                    .padding(.bottom, 35)
                    .multilineTextAlignment(.center)
                
                Button {
                    buttonAction()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.mint)
                            .frame(width: 100, height: 50)
                        
                        Text(buttonText)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.black)
                            .padding()
                    }
                }
            }
            .shadow(radius: 20)
        }
    }
}

#Preview {
    WeatherErrorView(backgroundImage: Constants.defaultBackground, headerImage: Constants.defaultHeader, errorImage: "thermometer.medium.slash", errorTitle: "Weather fetch failed", errorDescription: "Weather couldn't be fetched -", buttonText: "Retry", buttonAction: {})
}
