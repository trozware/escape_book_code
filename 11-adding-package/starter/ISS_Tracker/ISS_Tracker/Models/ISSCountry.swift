//
// ISSCountry.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Foundation

/// Struct to store the data returned from the `coordinates` endpoint.
///
/// Shows the country beneath the current ISS location.
///
/// If not over a country, `countryCode` will be "??" and `offset` will be 0.0.
///
/// `timeZone` always shows the number of hours difference from GMT but its code may be "Etc"
///
/// Do not change these property names - they match the JSON coming from the API.
struct ISSCountry: Decodable {
  let timezoneId: String
  let offset: Double
  let countryCode: String
}

extension ISSCountry: CustomDebugStringConvertible {
  /// printable description used when debugging
  var debugDescription: String {
    """
    ISSCountry:
      Country: \(countryCode)
      Offset: \(offset)
      Timezone: \(timezoneId)
    """
  }
}
