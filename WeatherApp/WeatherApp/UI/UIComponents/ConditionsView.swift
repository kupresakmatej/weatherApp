//
//  ConditionsView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import SwiftUI

struct ConditionsView: View {
    let viewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            Text("Conditions")
                .font(.title2)
                .bold()
                .padding([.top, .bottom])
            
            HStack {
                ConditionsPickerView(image: "humidity_icon", isChecked: viewModel.settings?.isHumidityShown ?? true, viewModel: viewModel)
                
                ConditionsPickerView(image: "pressure_icon", isChecked: viewModel.settings?.isPressureShown ?? true, viewModel: viewModel)
                
                ConditionsPickerView(image: "wind_icon", isChecked: viewModel.settings?.isWindShown ?? true, viewModel: viewModel)
            }
        }
    }
}

struct ConditionsPickerView: View {
    let image: String
    @State var isChecked: Bool
    let viewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            Button {
                if(image.contains("humidity")) {
                    viewModel.toggleHumidity()
                } else if(image.contains("pressure")) {
                    viewModel.togglePressure()
                } else  if(image.contains("wind")) {
                    viewModel.toggleWind()
                }
                isChecked.toggle()
            } label: {
                CheckmarkView(color: .black, checkPressed: isChecked)
            }
            
            ConditionImageView(image: image)
        }
    }
}

struct ConditionImageView: View {
    let image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.template)
            .resizable()
            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.1)
            .foregroundStyle(.black)
            .padding()
    }
}
