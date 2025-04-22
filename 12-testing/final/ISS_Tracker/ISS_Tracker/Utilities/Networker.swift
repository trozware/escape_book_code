//
// Networker.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Foundation
import OSLog

/// Helper struct to perform all communications with the API.
struct Networker {
  /// The base URL for all the API endpoints.
  let baseURL = URL(string: "https://api.wheretheiss.at/v1/")!

  /// The ID for the ISS as allocated by NORAD.
  let issID = 25544

  let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: "Networker"
  )

  /// Query the API endpoint for the current location of the ISS.
  ///
  /// If valid data is received, decode into an `ISSLocation`, otherwise throw a `FetchError`.
  /// - Returns: `ISSLocation`
  func fetchISSDetails() async throws -> ISSLocation {
    logger.debug("Fetching ISS details...")
    let url =
      baseURL
      .appendingPathComponent("satellites/\(issID)")

    let (data, response) = try await URLSession.shared.data(from: url)
    logger.warning("Received \(data.count) bytes of data.")
    guard let response = response as? HTTPURLResponse else {
      logger.error("No HTTP response received.")
      throw FetchError.noResponse
    }
    let code = response.statusCode
    logger.fault("HTTP status code \(code) received.")
    guard code >= 200 && code < 300 else {
      throw FetchError.badResponseCode(code: code)
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970

    do {
      let location = try decoder.decode(ISSLocation.self, from: data)
      logger.info("ISS details fetched successfully.")
      return location
    } catch {
      throw FetchError.badJSON(error: error)
    }
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
      throw FetchError.badResponseCode(code: code)
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    do {
      let country = try decoder.decode(ISSCountry.self, from: data)
      return country
    } catch {
      throw FetchError.badJSON(error: error)
    }
  }
}
