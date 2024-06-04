//
//  CheckmarkView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import SwiftUI

struct CheckmarkView: View {
    let color: Color
    let checkPressed: Bool
    
    var body: some View {
        Image(checkPressed ? "checkmark_check" : "checkmark_uncheck")
            .renderingMode(.template)
            .resizable()
            .frame(width: 28, height: 28)
            .foregroundStyle(color)
    }
}

#Preview {
    CheckmarkView(color: .black, checkPressed: true)
}
