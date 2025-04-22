//
// InspectorView.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import SwiftUI

struct InspectorView: View {
  let latitude = -12.944392865716
  let longitude = 1.0846205074539
  let altitude = 267.13
  let altitudeUnits = "miles"
  let velocity = 17123.86
  let velocityUnits = "mph"
  let daylight = true

  var body: some View {
    Form {
      Section("ISS") {
        LabeledContent("Latitude:") {
          Text("\(latitude, format: .number.precision(.fractionLength(3)))")
        }
        LabeledContent("Longitude:") {
          Text("\(longitude, format: .number.precision(.fractionLength(3)))")
        }
        LabeledContent("Altitude:") {
          Text("\(altitude, format: .number.precision(.fractionLength(1))) \(altitudeUnits)")
        }
        LabeledContent("Velocity") {
          Text("\(velocity, format: .number.precision(.fractionLength(1))) \(velocityUnits)")
        }
        LabeledContent("In Daylight:", value: daylight ? "Yes" : "No")
      }
    }
    .formStyle(.grouped)
  }
}

#Preview {
  InspectorView()
}
