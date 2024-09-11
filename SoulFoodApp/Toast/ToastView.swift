//
//  ToastView.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 11/9/24.
//

import Foundation
import SwiftUI

struct ToastView: View {
  
  var style: ToastStyle
  var message: String
  var width = CGFloat.infinity
  var onCancelTapped: (() -> Void)
  
  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      Image(systemName: style.iconFileName)
        .foregroundColor(style.themeColor)
        
      Text(message)
        .font(Font.caption)
        .foregroundColor(Color("toastForeground"))
      
      Spacer(minLength: 10)
      
      Button {
          print("TAPPED")
        onCancelTapped()
      } label: {
        Image(systemName: "xmark")
          .foregroundColor(style.themeColor)
      }
    }
    .padding()
    .frame(minWidth: 0, maxWidth: width)
    .background(Color("toastBackground").gradient)
    .cornerRadius(8)
    .overlay(
        RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1)
            .opacity(0.6)
    )
    .padding(.horizontal, 16)
  }
}
