//
// Networker.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Foundation

/// Helper struct to perform all communications with the API.
struct Networker {
  /// The base URL for all the API endpoints.
  let baseURL = URL(string: "https://api.wheretheiss.at/v1/")!

  /// The ID for the ISS as allocated by NORAD.
  let issID = 25544

  /// Query the API endpoint for the current location of the ISS.
  ///
  /// If valid data is received, decode into an `ISSLocation`, otherwise throw a `FetchError`.
  /// - Returns: `ISSLocation`
  func fetchISSDetails(units: DisplayUnits) async throws -> ISSLocation {
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

  /// Query the API endpoint for the country beneath the supplied latitude and longitude.
  ///
  /// If valid data is received, decode into an `ISSCountry`, otherwise throw a `FetchError`.
  ///
  /// - Parameters:
  ///   - latitude: latitude supplied from ISSLocation.
  ///   - longitude: longitude supplied from ISSLocation.
  /// - Returns: `ISSCountry`
  func fetchCountryDetails(
    latitude: Double,
    longitude: Double
  ) async throws -> ISSCountry {
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
