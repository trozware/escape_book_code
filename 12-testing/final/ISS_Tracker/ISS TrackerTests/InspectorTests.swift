//
// InspectorTests.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Testing
import SwiftUI
@testable import ISS_Tracker

@Suite("InspectorTests", .serialized)
struct InspectorTests {
  @AppStorage("displayUnits") var displayUnits: DisplayUnits = .kilometers

  @Test func altitudeWithUnits() async throws {
    let networker = Networker()
    let possibleLocation = try? await networker.fetchISSDetails()
    let issLocation = try #require(possibleLocation)

    let storedDisplayUnits: DisplayUnits = displayUnits
    defer {
      displayUnits = storedDisplayUnits
    }

    displayUnits = .kilometers
    #expect(issLocation.formattedAltitude.contains("kilomet"))

    displayUnits = .miles
    #expect(issLocation.formattedAltitude.hasSuffix("miles"))
  }

  @Test func velocityWithUnits() async throws {
    let networker = Networker()
    let possibleLocation = try? await networker.fetchISSDetails()
    let issLocation = try #require(possibleLocation)

    let storedDisplayUnits: DisplayUnits = displayUnits
    defer {
      displayUnits = storedDisplayUnits
    }

    displayUnits = .kilometers
    #expect(issLocation.formattedVelocity.hasSuffix("km/h"))

    displayUnits = .miles
    #expect(issLocation.formattedVelocity.hasSuffix("m.p.h."))
  }
}
