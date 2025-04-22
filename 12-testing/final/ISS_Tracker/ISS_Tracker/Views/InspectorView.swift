//
// InspectorView.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import SwiftUI

struct InspectorView: View {
  @Environment(AppState.self) var appState: AppState

  @AppStorage("displayUnits") var displayUnits: DisplayUnits = .kilometers

  var body: some View {
    Form {
      if let location = appState.issLocation, let country = appState.issCountry {
        Section("ISS") {
          LabeledContent("Last Update:", value: location.formattedDate)

          LabeledContent("Latitude:", value: location.formattedLatitude)

          LabeledContent("Longitude:", value: location.formattedLongitude)

          LabeledContent("Altitude:", value: location.formattedAltitude)

          LabeledContent("Velocity", value: location.formattedVelocity)

          LabeledContent("Visibility:", value: location.visibility)
        }

        Section("Country under the ISS") {
          LabeledContent("Country:", value: country.formattedCountry)

          LabeledContent("Time Zone:", value: country.timezoneId)

          LabeledContent("Time Zone Offset:", value: country.formattedOffset)
        }
      }
    }
    .id(displayUnits)
    .formStyle(.grouped)
    .overlay {
      if appState.issLocation == nil || appState.issCountry == nil {
        ContentUnavailableView(
          "Searching for the ISS…",
          systemImage: "magnifyingglass"
        )
      }
    }
  }
}

#Preview {
  InspectorView()
    .environment(AppState())
    .frame(height: 450)
}
