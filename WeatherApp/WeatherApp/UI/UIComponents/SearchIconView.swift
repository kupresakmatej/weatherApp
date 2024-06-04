//
//  SearchIconView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

struct SearchIconView: View {
    let color: Color
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Image("search_icon")
            .resizable()
            .renderingMode(.template)
            .frame(width: width, height: height)
            .padding()
            .foregroundStyle(color)
    }
}

#Preview {
    SearchIconView(color: .red, width: 48, height: 48)
}
