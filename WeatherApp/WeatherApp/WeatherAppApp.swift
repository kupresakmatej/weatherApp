//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
