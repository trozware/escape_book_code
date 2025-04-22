//
// Toolbar.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import SwiftUI

struct Toolbar: ToolbarContent {
  @Environment(AppState.self) var appState: AppState

  @AppStorage("autoRefresh") var autoRefresh = true

  var body: some ToolbarContent {
    ToolbarItem {
      Toggle(isOn: $autoRefresh) {
        Label("Auto refresh", systemImage: "autostartstop")
          .foregroundStyle(autoRefresh ? Color.red : .primary)
      }
    }

    ToolbarItem {
      Button("Refresh", systemImage: "arrow.clockwise") {
        appState.refresh()
      }
    }

    ToolbarItem {
      Button("Center", systemImage: "scope") {
        NotificationCenter.default.post(name: .shouldCenterMap, object: nil)
      }
    }
  }
}
