//
// AppState.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

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
      let newCountry = await fetchISSCountry(using: newLocation)

      await MainActor.run {
        issLocation = newLocation
        issCountry = newCountry

        print(issLocation ?? "No ISSLocation")
        print(issCountry ?? "No ISSCountry")
      }
    }
  }

  private func fetchISSLocation() async -> ISSLocation? {
    let newLocation = try? await networker.fetchISSDetails(units: displayUnits)
    return newLocation
  }

  private func fetchISSCountry(using location: ISSLocation?) async -> ISSCountry? {
    guard let location else {
      return nil
    }

    let newCountry = try? await networker.fetchCountryDetails(
      latitude: location.latitude,
      longitude: location.longitude
    )
    return newCountry
  }

  private func configTimer() {
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

  // MARK: - Computed Properties

  var currentISSCoordinate: CLLocationCoordinate2D {
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
