//
// FetchError.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

enum FetchError: Error {
  case noResponse
  case badResponseCode(code: Int)
  case badJSON(error: Error)
}
