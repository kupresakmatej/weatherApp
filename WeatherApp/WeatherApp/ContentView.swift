//
//  ContentView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthentificationViewModel()
    
    @State var isLoggedIn = false
    
    var body: some View {
        if isLoggedIn {
            HomeView(isLoggedIn: $isLoggedIn)
        } else {
            LoginView(authViewModel: authViewModel, isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    ContentView()
}

