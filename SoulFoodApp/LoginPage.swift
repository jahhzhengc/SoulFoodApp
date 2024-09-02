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

    var body: some View {
        if isLoggedIn {
            Text("Welcome, \(username)!")
        } else {
            VStack {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: login) {
                    Text("Login")
                }
                .padding()
            }
        }
    }

    func login() {
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
