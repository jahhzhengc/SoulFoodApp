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
                .onChange(of: email){ // newValue, oldValue in
                    print("\(email) and its regex matches = \(email.matches(EMAIL_REGEX))")
                }
            
            // this should send the backend the email given, and wait for the backend to generate code + sent the email, then go to next page
            NavigationLink{
                TypeYourVerificationCode(email: email)
                    .navigationTitle("Type your verification Code")
                    .navigationBarTitleDisplayMode(.inline)
            }label:{
                Button
                {
                    print("AG")
                }label:{
                    Text("Request Verification Code")
                        .frame(maxWidth:.infinity)
                }
                .buttonStyle(.borderedProminent)
//                .disabled(email.isEmpty )
                // disable when email is empty or email doesnt fulfill the format
                .padding(.top)
                
//                Text("Forgot password")
//                    .font(.footnote)
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .padding(.top)
            }
            
//            Button(action: pressed)
//            {
//                Text("Request Verification Code")
//                    .frame(maxWidth:.infinity)
//            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
    func pressed(){
        
    // "PayPal: Your security code is: xxxxxx. It expires in 10 minutes. Don't share this code with anyone."
    }
     
    private let EMAIL_REGEX: String = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    
  
    func checkEmail()->Bool {
        let toReturn = !(email.matches(EMAIL_REGEX));
//        print(toReturn)
        return toReturn;
    }
}

#Preview {
    ForgotPassword()
}
