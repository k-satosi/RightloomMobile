//
//  RightloomApp.swift
//  Shared
//

import SwiftUI

@main
struct RightloomApp: App {
    let authInfo = AuthInfo()
    let settings = Settings()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authInfo)
                .environmentObject(settings)
        }
    }
}
