//
// Menus.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import SwiftUI

struct Menus: Commands {
  @AppStorage("autoRefresh") var autoRefresh = true
  @AppStorage("displayMode") var displayMode = DisplayMode.auto

  let appState: AppState

  var body: some Commands {
    ToolbarCommands()
    InspectorCommands()

    mapMenu
    displayGroup
    helpGroup
  }

  var mapMenu: some Commands {
    CommandMenu("Map") {
      Toggle(isOn: $autoRefresh) {
        Label("Auto Refresh", systemImage: "autostartstop")
          .foregroundStyle(autoRefresh ? Color.red : .primary)
      }
      .keyboardShortcut("a", modifiers: [.shift, .command])

      Button("Refresh ISS Location", systemImage: "arrow.clockwise") {
        appState.refresh()
      }
      .keyboardShortcut("r")

      Button("Center Map on ISS", systemImage: "scope") {
        NotificationCenter.default.post(name: .shouldCenterMap, object: nil)
      }
      .keyboardShortcut("i")
    }
  }

  var displayGroup: some Commands {
    CommandGroup(after: .toolbar) {
      Picker("Display Mode", selection: $displayMode) {
        Text("Light").tag(DisplayMode.light).keyboardShortcut("L")
        Text("Dark").tag(DisplayMode.dark).keyboardShortcut("D")
        Text("Auto").tag(DisplayMode.auto).keyboardShortcut("U")
      }
    }
  }

  var helpGroup: some Commands {
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
}
