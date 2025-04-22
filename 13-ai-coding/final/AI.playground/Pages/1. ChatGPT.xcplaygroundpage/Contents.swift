//
// AI.playground - ChatGPT
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

// Chat GPT using GPT-4o

// Code block 1

import Foundation

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

  var positionDate: Date {
    return Date(timeIntervalSince1970: timestamp)
  }
}

// Code block 2

import Foundation

func fetchISSPosition() async throws -> ISSPosition {
  let url = URL(string: "https://api.wheretheiss.at/v1/satellites/25544")!
  let (data, response) = try await URLSession.shared.data(from: url)

  guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    throw URLError(.badServerResponse)
  }

  let decoder = JSONDecoder()
  let position = try decoder.decode(ISSPosition.self, from: data)
  return position
}

// Code block 3

import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

Task {
  do {
    let position = try await fetchISSPosition()
    print("ISS Position: \(position)")
    print("Timestamp as Date: \(position.positionDate)")
  } catch {
    print("Failed to fetch ISS position: \(error)")
  }
}

/*
 Explanation:

 Data Model (ISSPosition):
    This structure conforms to the Codable protocol, allowing easy decoding of JSON data. The positionDate computed property converts the timestamp into a Date object for convenience.

 Asynchronous Data Fetching (fetchISSPosition):
    This function constructs the URL for the API request, performs the network call asynchronously using URLSession, checks for a successful HTTP response, and decodes the JSON data into an ISSPosition instance.

 Error Handling and Testing:
    The Task block allows asynchronous code to run in a playground. The do-catch statement handles any errors that might occur during the data fetching or decoding process. Setting PlaygroundPage.current.needsIndefiniteExecution = true ensures that the playground continues running to allow asynchronous tasks to complete.

 Note: Ensure that your playground or project has access to asynchronous features, which are available in Swift 5.5 and later.
 */
