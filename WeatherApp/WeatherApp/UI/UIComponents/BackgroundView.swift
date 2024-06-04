//
//  BackgroundView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

struct BackgroundView: View {
    let backgroundImage: String
    let headerImage: String
    
    var body: some View {
        ZStack {
            VStack {
                Image("\(headerImage)")
                    .shadow(color: .gray, radius: 1, x: 0, y: 0)
                
                Image("\(backgroundImage)")
                    .resizable()
                    .ignoresSafeArea()
            }
        }
    }
}
