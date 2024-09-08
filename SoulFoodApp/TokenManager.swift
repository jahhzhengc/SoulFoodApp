//
//  TokenManager.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 8/9/24.
//

import Foundation
import SwiftUI

class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "auth_token"
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func removeToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    func wrappedRequest(sendReq: String) -> URLRequest{
        let url = URL(string: sendReq)! // force unwrapped it, probably not a good idea
        var toReturn = URLRequest(url: url)
        toReturn.addValue("application/json", forHTTPHeaderField: "Content-Type")
        toReturn.addValue("application/json", forHTTPHeaderField: "Accept")
        toReturn.setValue("Token \(getToken() ?? "")", forHTTPHeaderField: "Authorization")
        return toReturn
    }
}
