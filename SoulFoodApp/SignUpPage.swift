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
    @State private var repeatedPW: String = ""
     
    
    @State private var unError: Bool = false;
    @State private var emailError: Bool = false
    @State private var pwError: Bool = false
    @State private var repeatedPWError: Bool = false
    
    @State private var unErrorMsg = "";
    @State private var emailErrorMsg = "";
    @State private var pwErrorMsg = "";
    @State private var repeatedPWErrorMsg = "";
    
    @FocusState var focus: FocusedField?
    @FocusState var lastFocus : FocusedField?
    @State private var errorMsg : String = "BIG TEST"
    enum FocusedField:Hashable{
        case name, email, password, repeatedPW
    }
    var body: some View {
        ZStack{
//            Color.gray.opacity(0.5)
            VStack{
                VStack (alignment: .leading){
                    
                    Text("Username:")
                        .font(.caption2)
                        .foregroundStyle(unError ? Color.red : Color.black)
                        .padding(.horizontal)
                    
                    TextField("A unique username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .modifier(TextFieldErrorModifier(hasError: unError))
                        .focused($focus, equals: .name)
                        .padding(.horizontal)

                    if unError{
                        Text(unErrorMsg)
                            .foregroundStyle(unError ? Color.red : Color.black)
                            .font(.caption2)
                            .padding(.horizontal)
                    }
                    
                    Text("E-mail:")
                        .font(.caption2)
                        .foregroundStyle(emailError ? Color.red : Color.black)
                        .padding([.top, .horizontal])
                    
                    TextField("E.g: hello@gmail.com", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .modifier(TextFieldErrorModifier(hasError: emailError))
                        .focused($focus, equals: .email)
                        .padding(.horizontal)

                    
                    if emailError{
                        Text(emailErrorMsg)
                            .foregroundStyle(emailError ? Color.red : Color.black)
                            .font(.caption2)
                            .padding(.horizontal)
                    }
                    
                    Text("Password:")
                        .font(.caption2)
                        .foregroundStyle(pwError ? Color.red : Color.black)
                        .padding([.top, .horizontal])
                     
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .modifier(TextFieldErrorModifier(hasError: pwError))
                        .focused($focus, equals: .password)
                        .padding(.horizontal)
                    
                    if pwError{
                        Text(pwErrorMsg)
                            .foregroundStyle(pwError ? Color.red : Color.black)
                            .font(.caption2)
                            .padding(.horizontal)
                    }
                    
                    Text("Type password again:")
                        .font(.caption2)
                        .foregroundStyle( repeatedPWError ? Color.red : Color.black)
                        .padding([.top, .horizontal])
                    
                    SecureField("Type password again", text: $repeatedPW)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .modifier(TextFieldErrorModifier(hasError: repeatedPWError))
                        .focused($focus, equals: .repeatedPW)
                        .padding(.horizontal)
                    
                    
                    if repeatedPWError{
                        Text(repeatedPWErrorMsg)
                            .foregroundStyle(repeatedPWError ? Color.red : Color.black)
                            .font(.caption2)
                            .padding(.horizontal)
                    }
                    
                }
                .onChange(of: focus){ oldValue, newValue in
                    // on focus
                    switch(newValue!)
                    {
                        case .name:
                            unError = false

                        case .email:
                            emailError = false

                        case .password:
                            pwError = false

                        case .repeatedPW:
                            repeatedPWError = false
                    }
                    
                    if(oldValue == .name && newValue != .name){
                        if username.isEmpty{
                            unError = true
                            unErrorMsg = "Username cannot be empty!"
                            return
                        }
                    }
                    
                    if(oldValue == .email && newValue != .email){
                        if email.isEmpty{
                            emailError = true
                            emailErrorMsg = "Email cannot be empty!"
                            return
                        }
                        
                       emailError = checkEmail()
                        
                        if(emailError){
                            emailErrorMsg = "This is not a valid e-mail."
                        }
                    }
                    if(oldValue == .password && newValue != .password){
                        if password.isEmpty{
                            pwError = true
                            pwErrorMsg = "Password cannot be empty!"
                            return
                        }
                        pwError = checkPW()
                        
                        if(pwError){
                            pwErrorMsg = "Password must contain 8-20 alphanumeric characters and at least 1 special character!"
                        }
                        
                    }
                    if(oldValue == .repeatedPW && newValue != .repeatedPW){
                        if repeatedPW.isEmpty{
                            repeatedPWError = true
                            repeatedPWErrorMsg = "Password cannot be empty!"
                            return
                        }
                        repeatedPWError = repeatedPW != password
                        
                        if(repeatedPWError){
                            repeatedPWErrorMsg = "Please type your password again"
                        }
                    }
                   
                    
                }
                Button(action: signUp) {
                    Text("Sign up")
                }
                .buttonStyle(BorderedButtonStyle())
                .padding()
                 
            }
        }
    }
    
    func resetPW(){
        
    }
    private let EMAIL_REGEX: String = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    private let PW_REGEX: String = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,20}$";
    func signUp(){
        
        emailError = checkEmail()
        
//        unError = true
        pwError = checkPW()
        
        repeatedPWError = password != repeatedPW
        print("Password: \(password), repeated password: \(repeatedPW), hence its \(repeatedPWError)")
        // check if the email's used
        // check if email's following [aaa]@[aa].[aa]
        // check if pw is strong?
        // check if
    }
    
    func checkEmail()->Bool {
        return !(email.matches(EMAIL_REGEX));
    }
    func checkPW()->Bool{
        return !(password.matches(PW_REGEX))
    }
}

#Preview {
    SignUpPage()
}


// Custom ViewModifier to add red border on error
struct TextFieldErrorModifier: ViewModifier {
    var hasError: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(hasError ? Color.red : Color.black, lineWidth: 1.2) // Red border if error, gray otherwise
            )
    }
}


extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
