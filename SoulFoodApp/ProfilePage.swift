//
//  ProfilePage.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 15/10/24.
//

import SwiftUI

struct ProfilePage: View {
    @State private var showSheet = false
    
    enum SheetEnum: String {
        case birthday, language, login, address
    };
    @State private var currentEnum: SheetEnum? = .login
    
    @ObservedObject var tokenManager = TokenManager.shared
     
    var body: some View {
        if(tokenManager.loggedIn()){
            List{
                Section(header: Text("General")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.black)
                ){
                    Text("Favourites") // ideally all the favourite recipes?
//                    Text("Language") // ideally integrate localisation
                    Button("Set my birthday"){
                        currentEnum = .birthday
                        showSheet = true
                        print("IN")
                    }
                    
                    Button("Set my Address"){
                        currentEnum = .address
                        showSheet = true
                    }
                    
                    Text("Food reviews") // ideally they're allowed to drop feedback for ordered food
                    Text("Saved places") // ideally all the places thats stored
                }
                
                Section(header: Text("Support")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.black)
                ){
                    Text("Help center")
                    Text("Share feedbacks") // ideally all the places thats stored
                    Text("Terms & Policies")
                }
                
                Button (action:logOut){
                    Label("Log out", systemImage: "shield.lefthalf.filled.trianglebadge.exclamationmark")
                }
            }
            .listStyle(.grouped)
            .sheet(isPresented: isSheetPresented) {
                if (currentEnum == .birthday){
                    
                    SetBirthdayPage()
                        .presentationDetents([.medium, .large]) // Allows the sheet to be scrollable or full screen
                        .presentationDragIndicator(.visible)
                }
                else if (currentEnum == .address){
                    SetAddressPage()
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }
           
        }else{
             
            List{
                
                Button{ 
                    showSheet = true
                }label:{
                    Text("Sign up or Log in")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .tint(.indigo)
                .buttonStyle(.borderedProminent)
                .padding()
                // this should be the section that makes anon want to sign up
                
                Section(header: Text("Perks for you!")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.black)
                ){
                    Label("Subscribe to be a SoulMate!", systemImage: "crown.fill")
                    Label("Sign up and invite friends!", systemImage: "envelope.badge.fill")
                }
                
                Section(header: Text("General")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.black)
                ){
                    Text("Help center")
                    Text("Share feedbacks") // ideally all the places thats stored
                    Text("Terms & Policies")
                }
            }
            .listStyle(.inset)
            
            .sheet(isPresented: $showSheet) {
//                if(currentEnum == .login){
                    LoginPage(isPresented: $showSheet)
                        .presentationDetents([.medium, .large]) // Allows the sheet to be scrollable or full screen
                        .presentationDragIndicator(.visible)
//                }
            }
        }
    }
    func logOut(){ 
        var request = tokenManager.wrappedRequest(sendReq: "/auth/token/logout/")
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                tokenManager.removeToken()
                print("token removed!")
            }
        }.resume()
    }
    
    private var isSheetPresented: Binding<Bool> {
        Binding(
            get: { showSheet && currentEnum != nil },
            set: { newValue in
                showSheet = newValue
//                print("\(newValue) is set" ) 
            }
        )
    }

}

#Preview {
    ProfilePage()
}
