//
//  UseMap.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 15/10/24.
//
import SwiftUI

struct UseMap: View {
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            if let coordinate = locationManager.lastKnownLocation {
                Text("Latitude: \(coordinate.latitude)")
                
                Text("Longitude: \(coordinate.longitude)")
            } else {
                Text("Unknown Location")
            }
            
            
            Button("Get location") {
                locationManager.checkLocationAuthorization()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
struct UseMap_Previews: PreviewProvider {
    static var previews: some View {
        UseMap()
    }
}
