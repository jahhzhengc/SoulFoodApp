//
//  ForgotPassword.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 11/10/24.
//
import Combine
import SwiftUI
//import Just
struct ForgotPassword: View {
    @State private var email :String = ""
    
    @State private var code: [String] = Array(repeating: "", count: 6) // 6-digit code
    @FocusState private var focusedField: Int? // To keep track of the focused box
       
    var body: some View {
        VStack(alignment: .leading){
            
            Text("Please enter the email you used to sign up.")
                .padding(.vertical)
                .font(.title3)
                .bold()
            
            Text("Email: ")
                .font(.caption2)
            
            TextField("Please enter your email address", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.caption)
                .textInputAutocapitalization(.never)
            
            Button(action: pressed)
            {
                Text("Request Verification Code")
                    .frame(maxWidth:.infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.isEmpty || !email.matches(EMAIL_REGEX))
            // disable when email is empty or email doesnt fulfill the format
            .padding(.top)
            
            HStack(spacing: 10) {
              ForEach(0..<6, id: \.self) { index in
                  CodeBox(text: $code[index])
                      .focused($focusedField, equals: index) // Track the focused field
                      .onChange(of: code[index]) { oldValue, newValue in
//                          let cmp = (oldValue.count - newValue.count)
//                          if(cmp < 0){
////                              focusedField = max(index + 1, 5)
//                          }else{
////                              focusedField =
//                          }
//                          print(cmp)
                          print("oldValue: [\(oldValue)]")
                          print("newValue: [\(newValue)] && \(newValue.isEmpty)")
                          textChange(newValue: newValue, index: index)
////                          if(newValue == oldValue)
//                          if(newValue.isEmpty && index > 0){
//                              code[index] = "\u{200B}" // Reset the previous field
//                              focusedField = index - 1
//                              print("moved")
//                          }else{
//                              moveToEmptyField()
//                          }
//                          handleTextChange(newValue: newValue, index: index)
                      }
                      .onTapGesture {
                          moveToEmptyField() // Ensure the focus is always on the empty field
                      }
              }
          }
          .padding()
          .onAppear {
              focusedField = 0 // Focus the first box when the view appears
          }
          
            
            
            Spacer()
        }
        .padding(.horizontal)
    }
    func pressed(){
        
    }
    
    func textChange(newValue: String, index: Int){
        if(index > 0){
            if(newValue.isEmpty ){
                //            code[index] = "\u{200B}" // Reset the previous field
                focusedField = index - 1
                print("moved")
            }else{
                //            let nextIndex = index + 1
                //            code[nextIndex] = "\u{200B}"
                moveToEmptyField()
            }
        }
    }
    private func handleTextChange(newValue: String, index: Int) {
        // basically, they're all defaulted with a Zero Width space and also my index is defaulted to 0
        //
        if index > 0 && code[index].isEmpty {
            // If backspace detected in an empty field, move focus to the previous field
            focusedField = index - 1
            code[index] = "\u{200B}" // Reset the previous field
        } else if newValue.count == 1 && newValue != "\u{200B}" {
            // Move to the next box if a single character is entered and it's not the zero-width space
            focusedField = min(index + 1, 5)
        }
    }
    private let EMAIL_REGEX: String = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    
    private func moveToEmptyField() {
        if let firstEmptyIndex = code.firstIndex(where: { $0 == "\u{200B}" }) {
            focusedField = firstEmptyIndex
            print("Found")
        }else{
            print("nah")
        }
    }
    func checkEmail()->Bool {
        let toReturn = !(email.matches(EMAIL_REGEX));
        print(toReturn)
        return toReturn;
    }
}

struct CodeBox: View {
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
            .multilineTextAlignment(.center) // Center the text
            .frame(width: 40, height: 40) // Size of each box
            .keyboardType(.numberPad) // Show number-only keyboard
            .background(Color.gray.opacity(0.2)) // Light background color for the box
            .cornerRadius(5) // Rounded corners
            
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.blue, lineWidth: 2) // Border color
            )
            .padding(4)
            .textFieldStyle(PlainTextFieldStyle()) // Remove default styling
            .onAppear {
                // Ensure zero-width space is set on appear
                if text.isEmpty {
                    text = "\u{200B}"
                    print("overrides!")
                }
            }
//            .onReceive(Just(text)) { _ in
//                print(text)
//                if text.count > 1 {
//                    text = String(text.prefix(1))
//                }
//                
//            }
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
#Preview {
    ForgotPassword()
}
