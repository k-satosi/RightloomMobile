//
//  ContentView.swift
//  Shared
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            LoginView()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
