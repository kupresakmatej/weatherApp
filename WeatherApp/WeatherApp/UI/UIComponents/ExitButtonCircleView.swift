//
//  ExitButtonCircleView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import SwiftUI

struct ExitButtonCircleView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "x.circle")
                .padding()
                .font(.largeTitle)
                .tint(.black)
        }
    }
}

#Preview {
    ExitButtonCircleView()
}
