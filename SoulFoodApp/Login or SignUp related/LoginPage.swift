//
//  LoginPage.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 2/9/24.
//

import SwiftUI
import SwiftUI

struct LoginPage: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    
    @State private var errorMsg: Bool = false
    @ObservedObject private var tokenManager = TokenManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var loggingIn: Bool = false
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading){
                Text("Login")
                    .padding(.vertical)
                    .font(.title3)
                    .bold()
                
                Text("Username: ")
                    .font(.caption2)
                    .padding(.top)
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                
                Text("Password: ")
                    .font(.caption2)
                    .padding(.top)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: password){ oldValue, newValue in
                        // just clean up the warning when the pw is typed in
                        if newValue != "" &&  errorMsg {
                            errorMsg = false
                        }
                    }
                
                NavigationLink{
                    ForgotPassword()
                        .navigationTitle("Forgot password")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Text("Forgot password")
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.top)
                }
                .disabled(loggingIn)
                
                if !loggingIn{
                    Button(action: logIn) {
                        Text("Sign in")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                    .disabled(username.isEmpty || password.isEmpty || loggingIn)
                    .buttonStyle(.borderedProminent)
                }
                else{
                    ProgressView("Logging In...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .edgesIgnoringSafeArea(.all)
                        .onAppear{
                            print("SHOows up")
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding(.top)
                }
                
                HStack (alignment: .center){
                    Text("Dont have an account?")
                    NavigationLink{
                        SignUpPage()
                            .navigationTitle("Register a new account")
                            .navigationBarTitleDisplayMode(.inline)
                    }label:{
                        Text("Sign up")
                    }
                    .disabled(loggingIn)
                }
                .font(.footnote)
                .padding(.top)
                
                if errorMsg {
                    Text("User credentials are invalid!")
                        .font(.footnote)
                        .padding(.top)
                        .foregroundStyle(.red)
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear{
            username = ""
            password = ""
            if(tokenManager.loggedIn()){
                print("Already logged in")
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        
        
    }
     
    func loginError(){
        password = ""
        errorMsg = true
        loggingIn = false
    }
    
    func logIn(){
         
        let url = tokenManager.root + "/auth/token/login/"
        var request = tokenManager.wrappedRequest(sendReq: url)
        request.httpMethod = "POST"
        
        let json: [String: String] = ["username": username, "password" : password];
//            ["username": "test2", "password" : "vveegeer32"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        
        request.httpBody = jsonData
        loggingIn = true
        print(" Logging in is : [\(loggingIn)]")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 ){
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    loginError()
                    return
                }
                if let data = data {
                    
                    DispatchQueue.main.async {
                        do {
                            let json = try JSONDecoder().decode(Token.self, from: data)
                            tokenManager.saveToken(json.auth_token)
                            
                            loggingIn = false
                            self.presentationMode.wrappedValue.dismiss()
                            print("HERE" ,json.auth_token!)
                        } catch {
                            loginError()
                        }
                        
                        // Retrieving the token
                        //                    if let token = tokenManager.getToken() {
                        //                        print("Token retrieved: \(token)")
                        //                    } else {
                        //                        print("No token found")
                        //                    }
                    }
                }
            }.resume()
        }
    }
}


#Preview {
    LoginPage()
}
