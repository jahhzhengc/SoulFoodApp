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
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
//        if loggedIn() {
//            Text("Welcome, \(username)!")
//        } else {
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
                    
                    NavigationLink{
                        ForgotPassword()
                            .navigationTitle("Forgot password")
                            .navigationBarTitleDisplayMode(.inline)
                    }label:{
                        Text("Forgot password")
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.top)
                    }
                    
                    Button(action: login) {
                        Text("Sign in")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                    .disabled(username.isEmpty || password.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                    
                     
                    HStack (alignment: .center){
                        
                        Text("Dont have an account?")
                        NavigationLink{
                            SignUpPage()
                                .navigationTitle("Register a new account")
                                .navigationBarTitleDisplayMode(.inline)
                        }label:{
                            Text("Sign up")
                        } 
                    }
                    .font(.footnote)
                    .padding(.top)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .onAppear{
                    username = ""
                    password = ""
//                    print("test")
                }
        }
    }
     
     
    func login() {
        print ("login")
        
        self.presentationMode.wrappedValue.dismiss()
        guard let url = URL(string: "http://127.0.0.1:8000/api/login/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  
        let json: [String: String] = ["username": username,
                                   "password" : password]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
                
//                print(response!.statusCode)
                return
            }
            print(response!)
            if let data = data {
                // Here you might want to parse the response, but usually,
                // successful login just means handling the cookies
                DispatchQueue.main.async {
                    isLoggedIn = true
                }
                if let cookies = HTTPCookieStorage.shared.cookies {
                    for cookie in cookies {
                        
                        print("Name: \(cookie.name), Value: \(cookie.value)")
                    }
                }
            }
        }.resume()
    }
}


#Preview {
    LoginPage()
}
