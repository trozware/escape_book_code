//
// AppState.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import SwiftUI
import MapKit

/// Main data class used throughout the app.
///
/// This is declared in **ISSTrackerApp.swift** and passed on using `environment`.
///
/// To access it in any subview, use:
/// ```swift
/// @Environment(AppState.self) var appState: AppState
/// ```
///
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

  /// AppState init
  ///
  /// Calls `refresh()` to start downloading the current ISS location and country.
  ///
  /// Starts observing `UserDefaults` changes to handle the auto-refresh timer.
  /// This calls `configTimer()` on startup.
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

  /// Method to start the asynchronous download of ISS location and country data.
  ///
  /// Uses a `Task` to call the two async fetch methods, then switches to `MainActor` to update the UI.
  func refresh() {
    // Use a `Task` to call the two async methods.
    Task {
      let newLocation = await fetchISSLocation()
      let newCountry = await fetchISSCountry(using: newLocation)

      // Switch to the main actor before publishing so that UI updates happen on the main thread
      await MainActor.run {
        issLocation = newLocation
        issCountry = newCountry

        print(issLocation ?? "No ISSLocation")
        print(issCountry ?? "No ISSCountry")
      }
    }
  }

  /// Fetch information about the current location of the ISS.
  /// If the network call fails, return nil.
  ///
  /// This uses `Networker` to communicate with the API.
  ///
  /// - Returns: ISSLocation?
  private func fetchISSLocation() async -> ISSLocation? {
    let newLocation = try? await networker.fetchISSDetails(units: displayUnits)
    return newLocation
  }

  /// Fetch information about the country under the supplied `ISSLocation`.
  /// If the supplied location is nil or the network call fails, return nil.
  ///
  /// This uses `Networker` to communicate with the API.
  ///
  /// Usage:
  /// ```swift
  ///  let country = await fetchISSCountry(using: location)
  /// ```
  ///
  /// - Parameter location: ISSLocation?
  /// - Returns: ISSCountry?
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

  /// Private method for starting and stopping the auto refresh timer.
  ///
  /// This is called when `AppState` is initialized and whenever `UserDefaults` change.
  ///
  /// The timer is cancelled first, then re-started if `autoRefresh` is true, using the time interval from `refreshRate`.
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

  /// Computed property to convert latitude and longitude properties from `Double`
  /// into a `CLLocationCoordinate2D` for display in a Map.
  ///
  /// If there is no known ISSLocation, use 0, 0 as the default coordinate.
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
