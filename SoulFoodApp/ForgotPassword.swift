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
                          
                          
                          // means a backspace detected
                          if(newValue.isEmpty){
                              if(index > 0){
                                  focusedField = index - 1
                              }
                              // just hard set the indexes onward with empty white space
                              for j in index...5 {
                                  code[j] = "\u{200B}"
                              }
                              
                              // hard reset the index -1 to empty white space
                              if(index - 1 > -1){
                                  code[index - 1] = "\u{200B}"
                              }
                          }
                          else{
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
              focusedField = 0 // Focus the first box when the view appears
          }
          
            
            
            Spacer()
        }
        .padding(.horizontal)
    }
    func pressed(){
        
    }
     
    private let EMAIL_REGEX: String = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    
    private func moveToEmptyField() {
        if let firstEmptyIndex = code.firstIndex(where: { $0.count < 2 }) {
            focusedField = firstEmptyIndex
            print("Found \(firstEmptyIndex)")
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
                }
            }
            // just limit characters to number and zero-width space
            .onReceive(Just(text)) { newValue in
//                print(text.count)
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
