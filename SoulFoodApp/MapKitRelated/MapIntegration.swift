//
//  MapIntegration.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 15/10/24.
//
import MapKit
import SwiftUI

struct MapIntegration: View {
    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        MapReader { proxy in
            Map()
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        print(coordinate)
                    }
                }
                .mapStyle(.standard)
        }
    }
}

#Preview {
    MapIntegration()
}
