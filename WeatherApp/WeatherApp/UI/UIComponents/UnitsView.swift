//
//  UnitsPickerView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

struct UnitsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedUnit: String = "Metric"
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        if viewModel.settings?.isMetric ?? true {
            _selectedUnit = State(initialValue: "Metric")
        } else {
            _selectedUnit = State(initialValue: "Imperial")
        }
    }

    var body: some View {
        VStack {
            Text("Units")
                .font(.title2)
                .bold()
            
            VStack {
                UnitsContainerView(unit: "Metric", isSelected: selectedUnit == "Metric", selectUnit: {
                    self.selectedUnit = "Metric"
                    viewModel.toggleMetric()
                })
                UnitsContainerView(unit: "Imperial", isSelected: selectedUnit == "Imperial", selectUnit: {
                    self.selectedUnit = "Imperial"
                    viewModel.toggleMetric()
                })
            }
            .padding()
        }
    }
}

struct UnitsContainerView: View {
    let unit: String
    let isSelected: Bool
    let selectUnit: () -> Void
    
    var body: some View {
        Button(action: selectUnit) {
            HStack {
                CheckmarkView(color: .black, checkPressed: isSelected)
                Text("\(unit)")
                    .font(.headline)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                    .background(Color.white.opacity(0.2).clipShape(RoundedRectangle(cornerRadius: 25)))
                    .allowsHitTesting(false)
            )
        }
        .buttonStyle(.plain)
    }
}
