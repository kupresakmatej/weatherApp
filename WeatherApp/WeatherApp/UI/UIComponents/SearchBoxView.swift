//
//  SearchBoxView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 16.04.2024..
//

import SwiftUI

struct SearchBoxView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var searchText: String
    @FocusState var isFocused: Bool
    
    var hasLoadingFailed: Bool
    
    init(searchText: Binding<String>, hasLoadingFailed: Bool) {
        self._searchText = searchText
        self.hasLoadingFailed = hasLoadingFailed
    }
    
    var body: some View {
        HStack(alignment: .top) {
            SearchIconView(color: .black, width: 26, height: 26)
                .bold()
                .shadow(color: .black, radius: 2)
            
            TextField("Search for a city...", text: $searchText)
                .padding(.top)
                .submitLabel(.done)
                .focused($isFocused)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
                .shadow(color: .black, radius: 2)
        )
        .padding()
    }
}
