//
//  RegisterView.swift
//  WeatherApp
//
//  Created by Matej Kuprešak on 30.05.2024..
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var authViewModel: AuthentificationViewModel
    
    @State private var showingEmailAlert = false
    @State private var showingPasswordAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView(backgroundImage: Constants.defaultBackground, headerImage: Constants.defaultHeader)
            
            VStack {
                Text("Register")
                    .font(.system(size: 56))
                
                VStack {
                    InputBar(placeholder: "Name...", inputType: InputType.regular, input: $authViewModel.nameText)
                        .padding(.top, 20)
                    
                    InputBar(placeholder: "Email...", inputType: InputType.regular, input: $authViewModel.emailText)
                        .padding(.top, 10)
                    
                    InputBar(placeholder: "Password...", inputType: InputType.password, input: $authViewModel.passwordText)
                        .padding(.top, 10)
                    
                    Button {
                        do {
                            try authViewModel.registerUser()
                        } catch let error {
                            switch error {
                            case InputError.emailRegister:
                                showingEmailAlert = true
                                print("Invalid email")
                            case InputError.passwordRegister:
                                showingPasswordAlert = true
                                print("Invalid password")
                            case let authError as NSError:
                                print("Authentication error: \(authError.localizedDescription)")
                            default:
                                print("An unknown error occurred")
                            }
                        }
                    } label: {
                        RoundedButton(width: 200, height: 48, buttonText: "Register", buttonColor: Color.green)
                            .padding(.top, 25)
                    }
                    .alert("Email is not valid", isPresented: $showingEmailAlert) {
                        Button("Ok", role: .cancel) { }
                    }
                    .alert("Password is not valid", isPresented: $showingPasswordAlert) {
                        Button("Ok", role: .cancel) { }
                    }
                    .alert("Registered successfully", isPresented: $authViewModel.isRegisteredSuccessfully) {
                        Button("Ok", role: .cancel) { }
                    }
                }
            }
        }
        .onAppear {
            authViewModel.emailText = ""
            authViewModel.passwordText = ""
        }
    }
}

#Preview {
    RegisterView(authViewModel: AuthentificationViewModel())
}
