//
//  InputBar.swift
//  WeatherApp
//
//  Created by Matej Kuprešak on 30.05.2024..
//

import SwiftUI

enum InputType {
    case regular, password
}

struct InputBar: View {
    var placeholder: String
    @State var inputType: InputType
    @Binding var input: String
    
    var body: some View {
        if(inputType == InputType.regular) {
            TextField(placeholder, text: $input)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
                .border(.black)
        }
        else if(inputType == InputType.password) {
            SecureField(placeholder, text: $input)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
                .border(.black)
        }
    }
}
