//
// Networker.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Foundation

struct Networker {
  let baseURL = URL(string: "https://api.wheretheiss.at/v1/")!
  let issID = 25544

  func fetchISSLocation(units: DisplayUnits) async throws -> ISSLocation {
    let url =
      baseURL
      .appendingPathComponent("satellites/\(issID)")
      .appending(queryItems: [URLQueryItem(name: "units", value: units.rawValue)])

    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse else {
      throw FetchError.noResponse
    }
    let code = response.statusCode
    guard code >= 200 && code < 300 else {
      throw FetchError.badResponseCode
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    let location = try decoder.decode(ISSLocation.self, from: data)
    return location
  }

  func fetchCountryDetails(latitude: Double, longitude: Double) async throws -> ISSCountry {
    let url =
      baseURL
      .appendingPathComponent("coordinates/\(latitude),\(longitude)")

    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse else {
      throw FetchError.noResponse
    }
    let code = response.statusCode
    guard code >= 200 && code < 300 else {
      throw FetchError.badResponseCode
    }


    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let country = try decoder.decode(ISSCountry.self, from: data)
    return country
  }
}

enum FetchError: Error {
  case noResponse
  case badResponseCode
  case badJSON
}
