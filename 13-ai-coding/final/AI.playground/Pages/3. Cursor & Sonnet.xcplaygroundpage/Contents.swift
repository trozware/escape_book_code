//
// AI.playground - Cursor & Sonnet
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

// Cursor and Claude Sonnet 3.7

import Foundation

// MARK: - Data Models

struct ISSPosition: Codable {
  let name: String
  let id: Int
  let latitude: Double
  let longitude: Double
  let altitude: Double
  let velocity: Double
  let visibility: String
  let footprint: Double
  let timestamp: TimeInterval
  let daynum: Double
  let solar_lat: Double
  let solar_lon: Double
  let units: String

  var date: Date {
    return Date(timeIntervalSince1970: timestamp)
  }
}

// MARK: - Error Types

enum ISSError: Error {
  case invalidURL
  case networkError(Error)
  case decodingError(Error)
  case invalidResponse
  case serverError(statusCode: Int)
}

// MARK: - Network Service

func fetchISSPosition() async throws -> ISSPosition {
  guard let url = URL(string: "https://api.wheretheiss.at/v1/satellites/25544") else {
    throw ISSError.invalidURL
  }

  let (data, response) = try await URLSession.shared.data(from: url)

  guard let httpResponse = response as? HTTPURLResponse else {
    throw ISSError.invalidResponse
  }

  guard (200 ... 299).contains(httpResponse.statusCode) else {
    throw ISSError.serverError(statusCode: httpResponse.statusCode)
  }

  do {
    let decoder = JSONDecoder()
    let position = try decoder.decode(ISSPosition.self, from: data)
    return position
  } catch {
    throw ISSError.decodingError(error)
  }
}

// MARK: - For Playground Testing

// This needs to be wrapped in Task because we're using async/await in a playground
func trackISS() {
  Task {
    do {
      let issPosition = try await fetchISSPosition()
      print("ISS Position: \(issPosition)")
      print("Current location: \(issPosition.latitude)° N, \(issPosition.longitude)° E")
      print("Altitude: \(issPosition.altitude) \(issPosition.units)")
      print("Speed: \(issPosition.velocity) \(issPosition.units)/hour")
      print("Timestamp: \(issPosition.date)")
    } catch ISSError.invalidURL {
      print("Error: Invalid URL")
    } catch ISSError.networkError(let error) {
      print("Network error: \(error.localizedDescription)")
    } catch ISSError.decodingError(let error) {
      print("Decoding error: \(error.localizedDescription)")
    } catch ISSError.invalidResponse {
      print("Error: Invalid response from server")
    } catch ISSError.serverError(let statusCode) {
      print("Server error with status code: \(statusCode)")
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
    }
  }
}

// Call this function to execute the code in the playground
trackISS()

/*
Explanation:

 To use this code in a Swift playground:
   Create a new Swift playground in Xcode
   Copy all the code from the ISSTracker.swift file
   Run the playground

 The code:
   Creates a ISSPosition struct that matches the API response format
   Implements a custom error enum ISSError with different error cases
   Uses async/await for networking with proper error handling
   Converts the Unix timestamp to a Swift Date object
   Includes a function that wraps everything in a Task for running in a playground

 When run, it will fetch the current position of the ISS and display:
   Full position details
   Formatted latitude and longitude
   Altitude and speed with units
   Timestamp as a Date object
 */
