//
//  TestToast.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 11/9/24.
//

import SwiftUI
// taken from https://ondrej-kvasnovsky.medium.com/how-to-build-a-simple-toast-message-view-in-swiftui-b2e982340bd
struct TestToast: View {
    
    @State private var toast: Toast? = nil
    var body: some View {
        VStack(spacing: 32) {
              Button {
                toast = Toast(style: .success, message: "Saved.", width: 160)
              } label: {
                Text("Run (Success)")
              }
              
              Button {
                toast = Toast(style: .info, message: "Btw, you are a good person.")
              } label: {
                Text("Run (Info)")
              }
              
              Button {
                toast = Toast(style: .warning, message: "Beware of a dog!")
              } label: {
                Text("Run (Warning)")
              }
              
              Button {
                toast = Toast(style: .error, message: "Fatal error, blue screen level.")
              } label: {
                Text("Run (Error)")
              }
              
            }
            .toastView(toast: $toast)
    }
}

#Preview {
    TestToast()
}
