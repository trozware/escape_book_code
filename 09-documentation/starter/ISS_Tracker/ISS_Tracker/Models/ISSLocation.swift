//
// ISSLocation.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Foundation

struct ISSLocation: Decodable {
  let latitude: Double
  let longitude: Double
  let altitude: Double
  let velocity: Double
  let visibility: String
  let timestamp: Date
  let units: String
}
