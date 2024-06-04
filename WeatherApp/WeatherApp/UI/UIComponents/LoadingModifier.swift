//
//  LoadingModifier.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    @Binding var isLoading: Bool
    let backgroundImage: String
    let headerImage: String
    
    func body(content: Content) -> some View {
        
        if isLoading {
            ZStack {
                BackgroundView(backgroundImage: backgroundImage, headerImage: headerImage)
                    .ignoresSafeArea()
                
                if isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    }
                }
            }
        } else {
            content
        }
    }
}

extension View {
    func showLoading(isLoading: Binding<Bool>, backgroundImage: String, headerImage: String) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading, backgroundImage: backgroundImage, headerImage: headerImage))
    }
}
