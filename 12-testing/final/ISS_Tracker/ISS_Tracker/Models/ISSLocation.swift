//
// ISSLocation.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Foundation

/// Struct to store the data returned from the `satellites` endpoint.
///
/// `units` is either "miles" or "kilometers".
/// The values for `altitude` and `velocity` are pre-converted to the units.
///
/// Do not change these property names - they match the JSON coming from the API.
struct ISSLocation: Decodable {
  let latitude: Double
  let longitude: Double
  let altitude: Double
  let velocity: Double
  let visibility: String
  let timestamp: Date
  let units: String
}

/// Extension to provide formatted strings for display in the inspector.
extension ISSLocation {
  /// timestamp Date formatted to show no date and long time, including time zone
  var formattedDate: String {
    timestamp.formatted(date: .omitted, time: .complete)
  }

  /// latitude rounded to 3 decimal places.
  var formattedLatitude: String {
    latitude.formatted(.number.precision(.fractionLength(3)))
  }

  /// longitude rounded to 3 decimal places.
  var formattedLongitude: String {
    longitude.formatted(.number.precision(.fractionLength(3)))
  }

  /// altitude rounded to 1 decimal place, plus the selected units.
  /// Converted from the default kilometers if required and formatted using
  /// Measurement and MeasurementFormatter
  var formattedAltitude: String {
    let altitudeFormatter = MeasurementFormatter()
    altitudeFormatter.numberFormatter.maximumFractionDigits = 1
    altitudeFormatter.unitStyle = .long
    altitudeFormatter.unitOptions = .providedUnit

    let altitudeKm = Measurement(value: altitude, unit: UnitLength.kilometers)
    if displayUnits == .kilometers {
      let formattedAltitude = altitudeFormatter.string(from: altitudeKm)
      return formattedAltitude
    }

    let altitudeMiles = altitudeKm.converted(to: UnitLength.miles)
    let formattedMiles = altitudeFormatter.string(from: altitudeMiles)
    return formattedMiles
  }

  /// velocity rounded to 1 decimal place, plus the selected units.
  /// Converted from the default kilometers if required and formatted using
  /// Measurement and MeasurementFormatter
  var formattedVelocity: String {
    let velocityFormatter = MeasurementFormatter()
    velocityFormatter.numberFormatter.maximumFractionDigits = 0
    velocityFormatter.unitStyle = .short
    velocityFormatter.unitOptions = .providedUnit

    let velocityKmh = Measurement(value: velocity, unit: UnitSpeed.kilometersPerHour)
    if displayUnits == .kilometers {
      let formattedVelocity = velocityFormatter.string(from: velocityKmh)
      return formattedVelocity
    }

    let velocityMph = velocityKmh.converted(to: UnitSpeed.milesPerHour)
    let formattedMph = velocityFormatter.string(from: velocityMph)
    return formattedMph
  }

  /// Read the stored setting from UserDefaults, bypassing @AppStorage
  var displayUnits: DisplayUnits {
    let storedSetting = UserDefaults.standard.string(forKey: "displayUnits") ?? "kilometers"
    let selectedUnits = DisplayUnits(rawValue: storedSetting) ?? .kilometers
    return selectedUnits
  }
}

extension ISSLocation: CustomDebugStringConvertible {
  /// printable description used when debugging
  var debugDescription: String {
    """
    ISSLocation:
      Lat/Long: \(latitude), \(longitude)
      Altitude: \(altitude) \(units)
      Velocity: \(velocity) \(units) per hour
      Date: \(timestamp.formatted(date: .abbreviated, time: .complete))
    """
  }
}
