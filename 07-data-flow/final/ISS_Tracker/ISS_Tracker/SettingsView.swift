//
// SettingsView.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import SwiftUI

struct SettingsView: View {
  @AppStorage("refreshRate") var refreshRate: RefreshRate = .ten_seconds
  @AppStorage("displayUnits") var displayUnits: DisplayUnits = .kilometers

  var body: some View {
    Form {
      Picker("Refresh location every:", selection: $refreshRate) {
        Text("10 seconds").tag(RefreshRate.ten_seconds)
        Text("30 seconds").tag(RefreshRate.thirty_seconds)
        Text("1 minute").tag(RefreshRate.one_minute)
        Text("5 minutes").tag(RefreshRate.five_minutes)
        Text("10 minutes").tag(RefreshRate.ten_minutes)
      }

      Picker("Display units:", selection: $displayUnits) {
        Text("miles & mph").tag(DisplayUnits.miles)
        Text("kilometers & km/h").tag(DisplayUnits.kilometers)
      }
    }
    .pickerStyle(.menu)
    .navigationTitle("ISS Tracker Settings")
    .padding()
    .frame(width: 330, height: 100)
  }
}

#Preview {
  SettingsView()
}

enum RefreshRate: Int {
  case ten_seconds = 10
  case thirty_seconds = 30
  case one_minute = 60
  case five_minutes = 300
  case ten_minutes = 600

}

enum DisplayUnits: String {
  case miles
  case kilometers
}
