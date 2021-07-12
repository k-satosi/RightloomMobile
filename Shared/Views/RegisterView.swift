//
//  RegisterView.swift
//  Rightloom
//

import SwiftUI

struct RegisterView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    @State private var result = ""

    @EnvironmentObject var settings: Settings
    @EnvironmentObject var authInfo: AuthInfo

    var body: some View {
        VStack {
            Text("Rightloom")
                .font(.title)
                .padding()
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
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
            SecureField("Password Confirmation", text: $passwordConfirmation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.alphabet)
                .padding()
            Button(action: { () in
                authInfo.register(url: settings.serverURL, name: name, email: email, password: password, passwordConfirmation: passwordConfirmation) {result in
                    dump(result)
                    self.result = result!
//                    if error == nil {
//                        result = "success"
//                    } else {
//                        result = error!.localizedDescription
//                    }
                }
            } ) {
                Text("Register")
                    .padding()
            }.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))

            TextField("", text: $result)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(true)
                .padding()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
