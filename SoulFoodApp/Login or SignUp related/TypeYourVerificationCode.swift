//
//  TypeYourVerificationCode.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 22/10/24.
//

import SwiftUI
import Combine
struct TypeYourVerificationCode: View {
    
    @State private var code: [String] = Array(repeating: "", count: 6) // 6-digit code
    @FocusState private var focusedField: Int? // To keep track of the focused box
    
    
    let email: String
    let zeroWidthSpace  =  "\u{200B}"
    var body: some View {
        
        Text("The verification code is sent to \(email), please check your email.")
            .padding(.vertical)
            .font(.title3)
            .bold()
        
        HStack(spacing: 10) {
          ForEach(0..<6, id: \.self) { index in
              CodeBox(text: $code[index])
                  .focused($focusedField, equals: index) // Track the focused field
                  .onChange(of: code[index]) { oldValue, newValue in
                      
                      // means a backspace detected
                      if(newValue.isEmpty){
                          // move the focus - 1 if its not the first 1
                          if(index > 0){
                              focusedField = index - 1
                          }
                          
                          // just hard set the indexes onward with empty white space, this wouldn't make changes accordingly as the onChange is paying attention to code[index]
                          for j in index...5 {
                              code[j] = zeroWidthSpace
                          }
                          
                          // hard reset the index -1 to empty white space
                          if(index - 1 > -1){
                              code[index - 1] = zeroWidthSpace
                          }
                          
                      }else{
                          
                          moveToEmptyField()
                      }
                  }
                  .onTapGesture {
                      moveToEmptyField() // Ensure the focus is always on the empty field
                  }
          }
      }
      .padding()
      .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
              focusedField = 0 // Focus the first box when the view appears
         }
      }
    }
    
    private func moveToEmptyField() {
        // check for any boxes that contains lesser than 2 characters, usually should be zerowidthspace + a number
        if let firstEmptyIndex = code.firstIndex(where: { $0.count < 2 }) {
            focusedField = firstEmptyIndex
            print("Found \(firstEmptyIndex)")
        }else{
            //when all 6 is filled, should filter out the zero-width space
            print("nah \(code.joined())")
        }
    }
}

struct CodeBox: View {
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
            .multilineTextAlignment(.center)
            .frame(width: 40, height: 40)
            .keyboardType(.numberPad) // Show number-only keyboard
            .background(Color.gray.opacity(0.2))
            .textContentType(.oneTimeCode)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .padding(4)
            .textFieldStyle(PlainTextFieldStyle()) // Remove default styling
            .onAppear {
                // Ensure zero-width space is set on appear
                if text.isEmpty {
                    text = "\u{200B}"
                }
            }
            // just limit characters to number and zero-width space
            .onReceive(Just(text)) { newValue in
                if text.count > 2 {
                    text = String(text.prefix(2))
                }
//                let filtered = newValue.filter { "\u{200B}0123456789".contains($0) }
//                if(filtered != newValue){
//
//                }
//                print(filtered.count)
//                if(text.)
            }
    }
}

#Preview {
    TypeYourVerificationCode(email:"Test@gmail.com")
}
