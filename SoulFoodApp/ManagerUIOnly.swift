//
//  ManagerUIOnly.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 2/9/24.
//

import SwiftUI

struct ManagerUIOnly: View {
    @State private var manager : Bool = true
    let authTokenString = "auth_token"
    
    @AppStorage("auth_token") private var token : String = ""
    var body: some View {
        VStack{
//            let text = UserDefaults.standard.string(forKey: authTokenString) ?? "Not logged in"
            Text(token)
            Button(action: printCookies){
                Label("Print Cookies", systemImage: "list.bullet.indent")
            }
            Button(action: logIn){
                Label("Log In", systemImage: "cursorarrow.click")
            }
            Button(action: load){
                Label("Access Manager UI", systemImage: "cursorarrow.click")
            }
            Button(action:logOut){
                Label("Log out", systemImage: "rectangle.portrait.and.arrow.forward.fill")
            }
            Toggle(isOn: $manager){
                Text( "Log in as " + (self.manager ? "Manager" : "Customer"))
            }
        }
    }
    
    let loginURL = "http://127.0.0.1:8000/auth/token/login/"
    func logIn(){
//        guard let url = URL(string: loginURL) else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let url = TokenManager.shared.root + "/auth/token/login/"
        var request = TokenManager.shared.wrappedRequest(sendReq: url)
        request.httpMethod = "POST"
        
        let json: [String: String] = self.manager ?
            ["username": "manager", "password" : "manage.rial1257"]:
            ["username": "test2", "password" : "vveegeer32"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
                return
            }
            if let data = data {
                
                print("Login as \(self.manager ? "Manager" : "Customer" )")
                
              
                DispatchQueue.main.async {
                    
                    do {
                        let json = try JSONDecoder().decode(Token.self, from: data)
                        TokenManager.shared.saveToken(json.auth_token)
                        print("HERE" ,json.auth_token!)
                    } catch {
                        print("didnt work")
                    }

                    // Retrieving the token
                    if let token = TokenManager.shared.getToken() {
                        print("Token retrieved: \(token)")
                    } else {
                        print("No token found")
                    }
                }
                printCookies()
            }
        }.resume()
    }
    func printCookies(){
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                print("Name: \(cookie.name), Value: \(cookie.value)")
            }
        }
    }
    func logOut(){
//        guard let url = URL(string: "http://127.0.0.1:8000/api/logout/") else {
//            print("Invalid URL")
//            return
//        }
//        var request = URLRequest(url: url)
        
        let url = TokenManager.shared.root + "/auth/token/logout/"
//        let url = "http://127.0.0.1:8000/auth/token/logout/"
        var request = TokenManager.shared.wrappedRequest(sendReq: url)
        request.httpMethod = "POST"
//
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                TokenManager.shared.removeToken()
            }
//            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
     
    // accessing a API that requires authentication.
    // no need for explicit setting session id
    func load() {
        
//        guard let url = URL(string: "http://127.0.0.1:8000/api/manager/") else {
//            print("Invalid URL")
//            return
//        }
//        let url = "http://127.0.0.1:8000/api/manager/"
        let url = TokenManager.shared.root + "/api/manager/"
        var request = TokenManager.shared.wrappedRequest(sendReq: url)
//        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: String] {
                print(responseJSON.keys)
                print(responseJSON.values)
            }
//            print(data)
        }.resume()
    }
}

#Preview {
    ManagerUIOnly()
}
