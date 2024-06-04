//
//  CustomBackButtonView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

struct CustomBackButtonView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "arrow.left")
                .renderingMode(.template)
                .foregroundColor(.black)
                .font(.title)
        }
        .padding(.top)
    }
}

#Preview {
    CustomBackButtonView()
}
