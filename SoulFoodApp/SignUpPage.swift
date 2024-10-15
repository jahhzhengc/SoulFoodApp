//
//  SignUpPage.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 8/10/24.
//

import SwiftUI

struct SignUpPage: View {
    
    @State private var username: String = "test"
    @State private var email : String = "abc@gmail.com"
    @State private var password: String = "abc123@AB"
    @State private var repeatedPW: String = "abc123@AB"
     
    
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
    @Environment(\.presentationMode) var presentationMode
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
                    
                    TextField("A unique username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .modifier(TextFieldErrorModifier(hasError: unError))
                        .focused($focus, equals: .name)

                    if unError{
                        Text(unErrorMsg)
                            .foregroundStyle(unError ? Color.red : Color.black)
                            .font(.caption2)
                    }
                    
                    Text("E-mail:")
                        .font(.caption2)
                        .foregroundStyle(emailError ? Color.red : Color.black)
                        .padding(.top)
                    
                    TextField("E.g: hello@gmail.com", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .modifier(TextFieldErrorModifier(hasError: emailError))
                        .focused($focus, equals: .email)

                    
                    if emailError{
                        Text(emailErrorMsg)
                            .foregroundStyle(emailError ? Color.red : Color.black)
                            .font(.caption2)
                    }
                    
                    Text("Password:")
                        .font(.caption2)
                        .foregroundStyle(pwError ? Color.red : Color.black)
                        .padding(.top)
                     
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .modifier(TextFieldErrorModifier(hasError: pwError))
                        .focused($focus, equals: .password)
                    
                    if pwError{
                        Text(pwErrorMsg)
                            .foregroundStyle(pwError ? Color.red : Color.black)
                            .font(.caption2)
                    }
                    
                    Text("Type password again:")
                        .font(.caption2)
                        .foregroundStyle( repeatedPWError ? Color.red : Color.black)
                        .padding(.top)
                    
                    SecureField("Type password again", text: $repeatedPW)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .modifier(TextFieldErrorModifier(hasError: repeatedPWError))
                        .focused($focus, equals: .repeatedPW)
                    
                    
                    if repeatedPWError{
                        Text(repeatedPWErrorMsg)
                            .foregroundStyle(repeatedPWError ? Color.red : Color.black)
                            .font(.caption2)
                    }
                    
                }
                .padding(.horizontal)
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
                HStack(spacing: 0){
                    Text("By signing up you agree to our ") +
                    Text("Terms and Conditions ")
                        .foregroundStyle(.blue) +
                    Text("and ") +
                    Text("Privacy Policy")
                        .foregroundStyle(.blue)
                }
                .font(.caption2)
                .padding(.top)
                
                Button(action: signUp) {
                    Text("Sign up")
                }
                .buttonStyle(.borderedProminent)
                .disabled(username.isEmpty || password.isEmpty || email.isEmpty || repeatedPW.isEmpty)
                .padding()
                 
                HStack (spacing: 0){
                    Text("Already have an account? ")
                    Button{
                        print("Loggin")
                        self.presentationMode.wrappedValue.dismiss()
                    }label:{
                        Text("Login")
                    }
                }
                .font(.footnote)
                
               
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
         
        
        var request = TokenManager.shared.wrappedRequest(sendReq: TokenManager.shared.root + "/auth/users/")
        request.httpMethod = "POST"
  
        let json: [String: String] = ["username": username,
                                   "password" : password,
                                      "email" : email]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                do{
                    print(data)
//                    let decodedResponse = try JSONDecoder().decode([RecipeFavourite].self, from: data)
                    DispatchQueue.main.async{
                        
                       
                    }
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
                return
            }
            
        }
        .resume()

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
