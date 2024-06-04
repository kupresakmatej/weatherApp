//
//  LocationErrorToast.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 20.05.2024..
//

import SwiftUI

struct LocationErrorToast: View {
    @Environment(\.dismiss) var dismiss
    @State private var offset: CGFloat = 1000
    
    let errorImage: String
    let errorDescription: String
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Image(systemName: errorImage)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.red)
                
                Text(errorDescription)
                    .foregroundStyle(.white)
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.snappy) {
                    offset = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.smooth(duration: 5)) {
                        offset = 1000
                    }
                }
            }
        }
    }
}

struct LocationErrorToast_Previews: PreviewProvider {
    static var previews: some View {
        LocationErrorToast(errorImage: "location.slash.circle", errorDescription: "Failed to fetch the location")
    }
}
