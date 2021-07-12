//
//  ContentView.swift
//  Shared
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                LoginView().tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Login")
                }
                RegisterView().tabItem {
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text("Register")
                }
                SettingsView().tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthInfo()).environmentObject(Settings())
    }
}
