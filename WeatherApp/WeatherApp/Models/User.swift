//
//  User.swift
//  WeatherApp
//
//  Created by Matej Kuprešak on 30.05.2024..
//

import Foundation

class User: Codable {
    var id: UUID
    var name: String
    var email: String
    
    init(id: UUID, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}
