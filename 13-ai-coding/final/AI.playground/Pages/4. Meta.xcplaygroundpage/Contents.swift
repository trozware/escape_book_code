//
// AI.playground - Metaa
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

// Meta

import Foundation

// MARK: - ISSLocation

struct ISSLocation: Codable {
  let name: String
  let id: Int
  let latitude: Double
  let longitude: Double
  let altitude: Double
  let velocity: Double
  let visibility: String
  let footprint: Double
  let timestamp: Date
  let daynum: Double
  let solar_lat: Double
  let solar_lon: Double
  let units: String

  enum CodingKeys: String, CodingKey {
    case name
    case id
    case latitude = "latitude"
    case longitude = "longitude"
    case altitude = "altitude"
    case velocity = "velocity"
    case visibility = "visibility"
    case footprint = "footprint"
    case timestamp = "timestamp"
    case daynum = "daynum"
    case solar_lat = "solar_lat"
    case solar_lon = "solar_lon"
    case units = "units"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    id = try container.decode(Int.self, forKey: .id)
    latitude = try container.decode(Double.self, forKey: .latitude)
    longitude = try container.decode(Double.self, forKey: .longitude)
    altitude = try container.decode(Double.self, forKey: .altitude)
    velocity = try container.decode(Double.self, forKey: .velocity)
    visibility = try container.decode(String.self, forKey: .visibility)
    footprint = try container.decode(Double.self, forKey: .footprint)
    let timestampValue = try container.decode(Double.self, forKey: .timestamp)
    timestamp = Date(timeIntervalSince1970: timestampValue)
    daynum = try container.decode(Double.self, forKey: .daynum)
    solar_lat = try container.decode(Double.self, forKey: .solar_lat)
    solar_lon = try container.decode(Double.self, forKey: .solar_lon)
    units = try container.decode(String.self, forKey: .units)
  }
}

// MARK: - ISSLocationDownloader

class ISSLocationDownloader {
  func downloadISSLocation(completion: @escaping (Result<ISSLocation, Error>) -> Void) {
    guard let url = URL(string: "https://api.wheretheiss.at/v1/satellites/25544") else {
      completion(.failure(URLError(.badURL)))
      return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }

      guard let data = data else {
        completion(.failure(URLError(.badServerResponse)))
        return
      }

      do {
        let issLocation = try JSONDecoder().decode(ISSLocation.self, from: data)
        completion(.success(issLocation))
      } catch {
        completion(.failure(error))
      }
    }.resume()
  }
}

// MARK: - Testing in a Swift Playground

let downloader = ISSLocationDownloader()
downloader.downloadISSLocation { result in
  switch result {
  case .success(let issLocation):
    print("ISS Location:")
    print("Name: \(issLocation.name)")
    print("ID: \(issLocation.id)")
    print("Latitude: \(issLocation.latitude)")
    print("Longitude: \(issLocation.longitude)")
    print("Altitude: \(issLocation.altitude)")
    print("Velocity: \(issLocation.velocity)")
    print("Visibility: \(issLocation.visibility)")
    print("Footprint: \(issLocation.footprint)")
    print("Timestamp: \(issLocation.timestamp)")
    print("Daynum: \(issLocation.daynum)")
    print("Solar Lat: \(issLocation.solar_lat)")
    print("Solar Lon: \(issLocation.solar_lon)")
    print("Units: \(issLocation.units)")
  case .failure(let error):
    print("Error: \(error.localizedDescription)")
  }
}

/*
 Explanation:

 This code defines a ISSLocation struct that conforms to Codable and represents the ISS location data.
 It also defines an ISSLocationDownloader class that uses URLSession to download the ISS location
 data and decodes it into an ISSLocation instance.
 The downloadISSLocation method is asynchronous and uses a completion handler to return the result.

 In the testing section, an instance of ISSLocationDownloader is created and used to
 download the ISS location data. The result is then printed to the console.
 */
