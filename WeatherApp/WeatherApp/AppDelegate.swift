//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Matej Kuprešak on 30.05.2024..
//

import Foundation
import Firebase
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
