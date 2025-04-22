//
// APITests.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import Testing
@testable import ISS_Tracker

struct APITests {

  let rioCoords = (latitude: -22.91002, longitude: -43.20963)

  @Test func lookForISS() async {
    let networker = Networker()

    //  let issLocation = try? await networker.fetchISSDetails()
    //  #expect(issLocation != nil)

    var issLocation: ISSLocation?
    do {
      issLocation = try await networker.fetchISSDetails()
      #expect(issLocation != nil)
    } catch FetchError.noResponse {
      Issue.record("No response from API server")
    } catch FetchError.badResponseCode(let code) {
      Issue.record("Bad response code from API server: \(code)")
    } catch FetchError.badJSON(let error) {
      Issue.record(error, "Error decoding JSON from API server")
    } catch {
      Issue.record(error, "Unknown error (probably offline)")
    }
  }

  @Test func lookForCountry() async {
    let networker = Networker()

    var issCountry: ISSCountry?
    do {
      issCountry =
        try await networker
        .fetchCountryDetails(
          latitude: rioCoords.latitude,
          longitude: rioCoords.longitude
        )
      #expect(issCountry != nil)
    } catch FetchError.noResponse {
      Issue.record("No response from API server")
    } catch FetchError.badResponseCode(let code) {
      Issue.record("Bad response code from API server: \(code)")
    } catch FetchError.badJSON(let error) {
      Issue.record(error, "Error decoding JSON from API server")
    } catch {
      Issue.record(error, "Unknown error (probably offline)")
    }
  }
}
