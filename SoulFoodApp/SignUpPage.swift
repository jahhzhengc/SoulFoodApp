//
//  SignUpPage.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 8/10/24.
//

import SwiftUI

struct SignUpPage: View {
    @State private var username: String = ""
    @State private var email : String = ""
    @State private var password: String = ""
    
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.5)
            VStack (alignment: .leading){
                Text("Username")
                    .font(.caption2)
                
                TextField("", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .background(RoundedRectangle(cornerRadius: 50).fill(Color.red))
                    .padding()
                
                Text("Email")
                    .font(.caption2)
                
                TextField("Example: hello@gmail.com", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    
                    .background(RoundedRectangle(cornerRadius: 50).fill(Color.red))
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                //                .padding()
                
                Button(action: signUp) {
                    Text("Login")
                }
                .buttonStyle(BorderedButtonStyle())
                .padding()
            }
        }
    }
    
    private let EMAIL_REGEX: String = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    func signUp(){
        print(email.matches(EMAIL_REGEX))
        // check if the email's used
        // check if email's following [aaa]@[aa].[aa]
        // check if pw is strong?
        // check if
    }
}

#Preview {
    SignUpPage()
}
extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
