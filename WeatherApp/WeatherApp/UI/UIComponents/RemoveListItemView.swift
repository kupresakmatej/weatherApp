//
//  RemoveListItemView.swift
//  WeatherApp
//
//  Created by Matej Kupresak on 17.04.2024..
//

import SwiftUI

struct RemoveListItemView: View {
    var body: some View {
        Image(systemName: "x.square")
            .font(.title)
            .padding([.leading, .top, .bottom])
            .tint(.red)
    }
}

#Preview {
    RemoveListItemView()
}
