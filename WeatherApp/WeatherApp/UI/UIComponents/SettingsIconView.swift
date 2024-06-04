//
//  SettingsIconView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

struct SettingsIconView: View {
    let color: Color
    
    var body: some View {
        Image("settings_icon")
            .renderingMode(.template)
            .resizable()
            .frame(width: 48, height: 48)
            .foregroundStyle(color)
            .padding()
    }
}

#Preview {
    SettingsIconView(color: .black)
}
