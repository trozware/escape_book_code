//
// ISS_API.playground
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Foundation

//  let latitude = 8.4737491371165
//  let longitude = -76.634490257143

enum FetchError: Error {
  case noResponse
  case badResponseCode
  case badJSON
}

enum DisplayUnits: String {
  case miles
  case kilometers
}

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

    let jsonString = String(decoding: data, as: UTF8.self)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    let location = try decoder.decode(ISSLocation.self, from: data)
    return location
  }

  func fetchCountryDetails(latitude: Double, longitude: Double) async throws -> ISSCountry {
    let url =
      baseURL
      .appendingPathComponent("coordinates/\(latitude),\(longitude)")
    // .appending(queryItems: [URLQueryItem(name: "indent", value: "2")])

    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse else {
      throw FetchError.noResponse
    }
    let code = response.statusCode
    guard code >= 200 && code < 300 else {
      throw FetchError.badResponseCode
    }

    let jsonString = String(decoding: data, as: UTF8.self)

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let country = try decoder.decode(ISSCountry.self, from: data)
    return country
  }
}

let networker = Networker()

Task {
  do {
    let location = try await networker.fetchISSLocation(units: DisplayUnits.miles)
    print(location)
    let country = try await networker.fetchCountryDetails(
      latitude: location.latitude,
      longitude: location.longitude
    )
    print(country)
  } catch {
    print("Error: \(error)")
  }
}

struct ISSLocation: Decodable {
  let latitude: Double
  let longitude: Double
  let altitude: Double
  let velocity: Double
  let visibility: String
  let timestamp: Date
  let units: String
}

struct ISSCountry: Decodable {
  let timezoneId: String
  let offset: Double
  let countryCode: String
}
