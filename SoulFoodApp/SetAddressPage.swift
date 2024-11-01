//
//  SetAddressPage.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 1/11/24.
//

import SwiftUI

struct SetAddressPage: View {
    @State private var address1 : String = ""
    @State private var address2 : String = ""
    @State private var address3 : String = ""
    @State private var address4 : String = ""
    
    @ObservedObject var tokenManager = TokenManager.shared
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack{
            TextField("Address", text: $address1)
            
            TextField("Address", text: $address2)
            TextField("Address", text: $address3)
            TextField("Address", text: $address4)
            
            Button("Changed"){
                self.dismiss()
            }
            .buttonStyle(BorderedProminentButtonStyle())
        }
    }
}

#Preview {
    SetAddressPage()
}
