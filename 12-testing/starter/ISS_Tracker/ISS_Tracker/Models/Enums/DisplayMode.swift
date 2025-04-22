//
// DisplayMode.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import SwiftUI

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
