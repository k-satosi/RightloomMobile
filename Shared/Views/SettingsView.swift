//
//  Settings.swift
//  Rightloom
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        VStack {
            Text("Rightloom")
                .font(.title)
                .padding()
            HStack {
                Text("Server URL")
                    .padding(.horizontal)
                Spacer()
            }
            TextField("Server URL", text: $settings.serverURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(true)
                .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(Settings())
    }
}
