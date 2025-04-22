//
// AI.playground - GitHub Copilot
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

// GitHub Copilot and Gemini 2.0 Flash

// Code block 1

// Swift
import Foundation

struct ISSPosition: Decodable {
  let latitude: String
  let longitude: String
}

struct ISSResponse: Decodable {
  let iss_position: ISSPosition
  let timestamp: Int
  let message: String
}

// Code block 2

// Swift
import Foundation

enum NetworkError: Error {
  case invalidURL
  case invalidResponse
  case decodingError
}

func getISSLocation() async throws -> ISSResponse {
  guard let url = URL(string: "https://api.wheretheiss.at/v1/satellites/25544") else {
    throw NetworkError.invalidURL
  }

  let (data, response) = try await URLSession.shared.data(from: url)

  guard let httpResponse = response as? HTTPURLResponse,
    httpResponse.statusCode == 200
  else {
    throw NetworkError.invalidResponse
  }

  do {
    let decoder = JSONDecoder()
    let issResponse = try decoder.decode(ISSResponse.self, from: data)
    return issResponse
  } catch {
    throw NetworkError.decodingError
  }
}

func formatDate(timestamp: Int) -> Date {
  return Date(timeIntervalSince1970: TimeInterval(timestamp))
}

// Example usage in a playground:
Task {
  do {
    let issData = try await getISSLocation()
    let latitude = issData.iss_position.latitude
    let longitude = issData.iss_position.longitude
    let timestamp = issData.timestamp
    let date = formatDate(timestamp: timestamp)

    print("Latitude: \(latitude)")
    print("Longitude: \(longitude)")
    print("Date: \(date)")
  } catch {
    print("Error: \(error)")
  }
}

/*
 Explanation:

 This code defines a NetworkError enum for error handling, an asynchronous function getISSLocation()
 to fetch and decode the data, and a formatDate() function to convert the timestamp to a Date object.
 It then calls these functions within a Task to execute the asynchronous code in a playground environment.
 */
