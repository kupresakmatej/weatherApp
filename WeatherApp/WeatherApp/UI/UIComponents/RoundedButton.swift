//
//  RoundedButton.swift
//  WeatherApp
//
//  Created by Matej Kuprešak on 30.05.2024..
//

import SwiftUI

struct RoundedButton: View {
    var width: CGFloat
    var height: CGFloat
    var buttonText: String
    var buttonColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: width, height: height)
                .foregroundColor(buttonColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.black, lineWidth: 2)
                )
            
            Text(buttonText)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    RoundedButton(width: 200, height: 48, buttonText: "Login", buttonColor: Color.gray)
}
