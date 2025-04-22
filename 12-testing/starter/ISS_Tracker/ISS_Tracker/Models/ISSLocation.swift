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
