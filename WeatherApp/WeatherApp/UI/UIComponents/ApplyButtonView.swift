//
//  ApplyButtonView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import SwiftUI

struct ApplyButtonView: View {
    let viewModel: SettingsViewModel
    
    var body: some View {
        Button {
            viewModel.applyChanges()
        } label: {
            Text("Apply")
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 2)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                        .background(Color.white.opacity(0.2).clipShape(RoundedRectangle(cornerRadius: 15)))
                        .allowsHitTesting(false)
                )
        }
        .buttonStyle(.plain)
    }
}
