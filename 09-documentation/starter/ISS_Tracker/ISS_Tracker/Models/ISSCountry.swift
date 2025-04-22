//
// ISSCountry.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Foundation

struct ISSCountry: Decodable {
  let timezoneId: String
  let offset: Double
  let countryCode: String
}
