//
// AppState.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Foundation
import SwiftUI
import MapKit

@Observable
class AppState {
  let networker = Networker()
  var issLocation: ISSLocation?
  var issCountry: ISSCountry?
  var refreshTimer: Timer?

  @AppStorage("displayUnits") @ObservationIgnored private var displayUnits: DisplayUnits =
    .kilometers
  @AppStorage("autoRefresh") @ObservationIgnored private var autoRefresh = true
  @AppStorage("refreshRate") @ObservationIgnored private var refreshRate: RefreshRate = .ten_seconds

  init() {
    refresh()

    NotificationCenter.default.addObserver(
      forName: UserDefaults.didChangeNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      self?.configTimer()
    }
  }

  func refresh() {
    Task {
      let newLocation = await fetchISSLocation()
      let newCountry = await fetchISSCountry(location: newLocation)

      await MainActor.run {
        issLocation = newLocation
        issCountry = newCountry

        print(issLocation ?? "No ISSLocation")
        print(issCountry ?? "No ISSCountry")
      }
    }
  }

  func fetchISSLocation() async -> ISSLocation? {
    let newLocation = try? await networker.fetchISSLocation(units: displayUnits)
    return newLocation
  }

  func fetchISSCountry(location: ISSLocation?) async -> ISSCountry? {
    guard let location else {
      return nil
    }

    let newCountry = try? await networker.fetchCountryDetails(
      latitude: location.latitude,
      longitude: location.longitude
    )
    return newCountry
  }

  func configTimer() {
    refreshTimer?.invalidate()
    refreshTimer = nil

    if autoRefresh == false {
      return
    }

    let refreshInterval = TimeInterval(refreshRate.rawValue)
    refreshTimer = Timer.scheduledTimer(
      withTimeInterval: refreshInterval,
      repeats: true
    ) { _ in
      self.refresh()
    }
  }

  var issCoordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
      latitude: issLocation?.latitude ?? 0.0,
      longitude: issLocation?.longitude ?? 0.0
    )
  }

  var velocityUnits: String {
    guard let issLocation else {
      return ""
    }

    if issLocation.units == "miles" {
      return "mph"
    }
    return "km/h"
  }
}
