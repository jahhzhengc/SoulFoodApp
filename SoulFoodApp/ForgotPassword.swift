//
//  ForgotPassword.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 11/10/24.
//

import SwiftUI

struct ForgotPassword: View {
    @State private var email :String = ""
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
            Spacer()
        }
        .padding(.horizontal)
    }
    func pressed(){
        
    }
    
    private let EMAIL_REGEX: String = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    
    func checkEmail()->Bool {
        let toReturn = !(email.matches(EMAIL_REGEX));
        print(toReturn)
        return toReturn;
    }
}

#Preview {
    ForgotPassword()
}
