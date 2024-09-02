//
//  ManagerUIOnly.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 2/9/24.
//

import SwiftUI

struct ManagerUIOnly: View {
    var body: some View {
        VStack{
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
        }
    }
    func logIn(){
        guard let url = URL(string: "http://127.0.0.1:8000/api/login/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  
        let json: [String: String] = ["username": "manager",
                                   "password" : "manage.rial1257"]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
                return
            }
            print(response!)
            if let data = data {
                // Here you might want to parse the response, but usually,
                // successful login just means handling the cookies
                DispatchQueue.main.async {
                    print("Logged In")
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
        guard let url = URL(string: "http://127.0.0.1:8000/api/logout/") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(data)
                print(response!)
                  
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    // accessing a API that requires authentication.
    // no need for explicit setting session id
    func load() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/manager") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(data)
                print(response!)
                  
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

#Preview {
    ManagerUIOnly()
}
