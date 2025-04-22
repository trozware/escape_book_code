//
// ContentView.swift
// Escape from Tutorial Hell
// Version 1.0
//
// by Sarah Reichelt
//

import SwiftUI
import MapKit

struct ContentView: View {
  let location = CLLocationCoordinate2D(
    latitude: -12.944392865716,
    longitude: 1.0846205074539
  )

  @State private var position = MapCameraPosition.automatic
  @State private var showInspector = false

  var body: some View {
    Map(position: $position) {
      Annotation("ISS", coordinate: location) {
        ZStack {
          RoundedRectangle(cornerRadius: 5)
            .fill(Color.white.opacity(0.3))
          Text("🛰️")
            .font(.system(size: 30))
            .padding(5)
        }
        .onTapGesture {
          showInspector.toggle()
        }
      }
    }
    .mapControlVisibility(.hidden)
    .onAppear {
      position = .camera(
        MapCamera(
          centerCoordinate: location,
          distance: 40_000_000
        )
      )
    }
    .inspector(isPresented: $showInspector) {
      InspectorView()
    }
  }
}

#Preview {
  ContentView()
}
