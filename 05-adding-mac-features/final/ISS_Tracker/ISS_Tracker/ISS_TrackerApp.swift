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
  @AppStorage("autoRefresh") var autoRefresh = true
  @AppStorage("displayMode") var displayMode = DisplayMode.auto

  var body: some Scene {
    Window("ISS Tracker", id: "iss_tracker_window") {
      ContentView()
        .onAppear {
          DisplayMode.changeDisplayMode(to: displayMode)
        }
        .onChange(of: displayMode) { _, newValue in
          DisplayMode.changeDisplayMode(to: newValue)
        }
    }
    .commands {
      ToolbarCommands()
      InspectorCommands()

      CommandMenu("Map") {
        Toggle(isOn: $autoRefresh) {
          Label("Auto Refresh", systemImage: "autostartstop")
            .foregroundStyle(autoRefresh ? Color.red : .primary)
        }
        .keyboardShortcut("a", modifiers: [.shift, .command])

        Button("Refresh ISS Location", systemImage: "arrow.clockwise") {
          print("Refresh ISS location")
        }
        .keyboardShortcut("r")

        Button("Center Map on ISS", systemImage: "scope") {
          NotificationCenter.default.post(name: .shouldCenterMap, object: nil)
        }
        .keyboardShortcut("i")
      }

      CommandGroup(after: .toolbar) {
        Picker("Display Mode", selection: $displayMode) {
          Text("Light").tag(DisplayMode.light).keyboardShortcut("L")
          Text("Dark").tag(DisplayMode.dark).keyboardShortcut("D")
          Text("Auto").tag(DisplayMode.auto).keyboardShortcut("U")
        }
      }

      CommandGroup(replacing: .help) {
        // EmptyView()

        Button("Where is ISS at?") {
          let address = "https://wheretheiss.at"
          if let url = URL(string: address) {
            NSWorkspace.shared.open(url)
          }
        }

        Button("Online Help Page") {
          let address = "https://troz.net"
          if let url = URL(string: address) {
            NSWorkspace.shared.open(url)
          }
        }

        Divider()

        NavigationLink("Help") {
          Text("Create a new view with some Help.")
            .padding()
        }
      }
    }

    Settings {
      SettingsView()
    }
  }
}

extension Notification.Name {
  static let shouldCenterMap = Notification.Name("shouldCenterMap")
}

enum DisplayMode: Int {
  case light
  case dark
  case auto

  static func changeDisplayMode(to mode: DisplayMode) {
    @AppStorage("displayMode") var displayMode = DisplayMode.auto
    displayMode = mode

    switch mode {
    case .light:
      NSApp.appearance = NSAppearance(named: .aqua)
    case .dark:
      NSApp.appearance = NSAppearance(named: .darkAqua)
    case .auto:
      NSApp.appearance = nil
    }
  }
}
