//
//  LoginView.swift
//  Rightloom
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var authInfo: AuthInfo
    @State private var isLogin = false
    
    var body: some View {
        VStack {
            Text("Rightloom")
                .font(.title)
                .padding()
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.alphabet)
                .padding()
            Button(action: { () in
                let url = settings.serverURL + "/api/sanctum/token"
                authInfo.login(url: url, email: email, password: password) {result in
                    isLogin = result
                }
            } ) {
                Text("Login")
                    .padding()
            }.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
            
            NavigationLink(
                destination: PhotoGridView().environmentObject(authInfo), isActive: $isLogin) {
                EmptyView()
            }.hidden()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthInfo())
            .environmentObject(Settings())
    }
}
