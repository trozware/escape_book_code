//
// ISS_TrackerApp.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import SwiftUI

@main
struct ISS_TrackerApp: App {
  @State var appState = AppState()

  @AppStorage("displayMode") var displayMode = DisplayMode.auto

  var body: some Scene {
    Window("ISS Tracker", id: "iss_tracker_window") {
      ContentView()
        .environment(appState)
        .onAppear {
          DisplayMode.changeDisplayMode(to: displayMode)
        }
        .onChange(of: displayMode) { _, newValue in
          DisplayMode.changeDisplayMode(to: newValue)
        }
    }
    .commands {
      Menus(appState: appState)
    }

    Settings {
      SettingsView()
    }
  }
}
