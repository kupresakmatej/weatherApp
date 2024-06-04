//
//  LocationErrorDialogView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 20.05.2024..
//

import SwiftUI

struct WeatherErrorDialogView: View {
    @Binding var isActive: Bool
    
    let errorImage: String
    let errorTitle: String
    let errorDescription: String
    let buttonText: String
    let buttonAction: () -> ()
    
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
                .opacity(0.1)
                .onTapGesture {
                    close()
                }
            
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        
                        Text(errorTitle)
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Image(systemName: errorImage)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.red)
                        
                        Spacer()
                    }
                    .padding(.bottom)
                }
                
                Text(errorDescription)
                    .font(.body)
                    .padding(.bottom, 35)
                
                Button {
                    buttonAction()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.mint)
                        
                        Text(buttonText)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.black)
                            .padding()
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            close()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .tint(.black)
                                .fontWeight(.medium)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .shadow(radius: 20)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.bouncy) {
                    offset = 0
                }
            }
        }
    }
    
    func close() {
        withAnimation(.bouncy) {
            offset = 1000
            isActive = false
        }
    }
}

#Preview {
    WeatherErrorDialogView(isActive: .constant(true), errorImage: "location.slash.fill", errorTitle: "Location fetch failed", errorDescription: "The location couldn't be fetched for some reason. Try again.", buttonText: "Retry", buttonAction: {})
}
