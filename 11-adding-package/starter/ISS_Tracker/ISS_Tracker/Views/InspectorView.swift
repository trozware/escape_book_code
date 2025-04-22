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
          LabeledContent("Last Update:") {
            Text(location.timestamp.formatted(date: .omitted, time: .complete))
          }

          LabeledContent("Latitude:") {
            Text("\(location.latitude, format: .number.precision(.fractionLength(3)))")
          }
          LabeledContent("Longitude:") {
            Text("\(location.longitude, format: .number.precision(.fractionLength(3)))")
          }
          LabeledContent("Altitude:") {
            Text(
              "\(location.altitude, format: .number.precision(.fractionLength(1))) \(location.units)"
            )
          }
          LabeledContent("Velocity") {
            Text(
              "\(location.velocity, format: .number.precision(.fractionLength(1))) \(appState.velocityUnits)"
            )
          }
          LabeledContent("Visibility:", value: location.visibility)
        }

        Section("Country under the ISS") {
          LabeledContent("Country Code:") {
            Text("\(getFlag(from: country.countryCode)) \(country.countryCode)")
          }
          LabeledContent("Time Zone:") {
            Text(country.timezoneId)
          }
          LabeledContent("Time Zone Offset:") {
            Text("\(country.offset)")
          }
        }
      }
    }
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

  func getFlag(from countryCode: String) -> String {
    if countryCode == "??" {
      return "🐳"
    }

    let scalars = countryCode.unicodeScalars
    let scalarInts = scalars.map { 127397 + $0.value }
    let unicodeScalars = scalarInts.compactMap(UnicodeScalar.init)
    let emojiString = unicodeScalars.map(String.init).joined()
    return emojiString
  }
}

#Preview {
  InspectorView()
    .environment(AppState())
    .frame(height: 450)
}
