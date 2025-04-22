//
// ISSCountry.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Foundation
import IsoCountryCodes

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

/// Extension to provide formatted strings for display in the inspector.
extension ISSCountry {
  /// offset rounded to 3 decimal places.
  var formattedOffset: String {
    offset.formatted(.number.precision(.fractionLength(1)))
  }

  /// convenience property to merge the flag emoji and country name into a single string
  var formattedCountry: String {
    if countryCode == "??" {
      return "🐳"
    }

    let flag = getFlag(from: countryCode)
    let name = getCountryName(from: countryCode)

    return "\(flag) \(name)"
  }

  /// Find the Emoji that shows the flag for the country by code.
  ///
  /// This has two different implementations.
  /// The active one uses the IsoCountryCodes package.
  /// The commented out one uses a version of some code I found on StackOverflow!
  /// - Parameter countryCode: two letter international code
  /// - Returns: a whale emoji if there's no country, otherwise a flag
  func getFlag(from countryCode: String) -> String {
    if countryCode == "??" {
      return "🐳"
    }

    //    let scalars = countryCode.unicodeScalars
    //    let scalarInts = scalars.map { 127397 + $0.value }
    //    let unicodeScalars = scalarInts.compactMap(UnicodeScalar.init)
    //    let emojiString = unicodeScalars.map(String.init).joined()
    //    return emojiString

    let emojiString = IsoCountries.flag(countryCode: countryCode)
    return emojiString ?? ""
  }

  /// Find the full name for the country by code.
  /// - Parameter countryCode: two letter international code
  /// - Returns: An empty string if the code is "??", otherwise the country name.
  func getCountryName(from countryCode: String) -> String {
    if countryCode == "??" {
      return ""
    }
    if let countryInfo = IsoCountryCodes.find(key: countryCode) {
      return countryInfo.name
    }
    return countryCode
  }
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
