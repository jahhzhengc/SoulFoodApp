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
    
    @ObservedObject var tokenManager = TokenManager.shared
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
     
    func logIn(){
        
//        ["username": "test2", "password" : "vveegeer32"]
        var request = tokenManager.wrappedRequest(sendReq: "/auth/token/login/")
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
                        tokenManager.saveToken(json.auth_token)
                        print("HERE" ,json.auth_token!)
                    } catch {
                        print("didnt work")
                    }

                    // Retrieving the token
                    if let token = tokenManager.getToken() {
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
         
//        let url = "http://127.0.0.1:8000/auth/token/logout/"
        var request = tokenManager.wrappedRequest(sendReq:  "/auth/token/logout/")
        request.httpMethod = "POST"
//
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                tokenManager.removeToken()
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
        let request = tokenManager.wrappedRequest(sendReq:  "/api/manager/")
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
