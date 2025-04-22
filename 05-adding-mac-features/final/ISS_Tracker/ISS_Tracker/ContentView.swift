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

  @AppStorage("autoRefresh") var autoRefresh = true

  @State private var position = MapCameraPosition.automatic
  @State private var currentMapCamera: MapCamera?
  @State private var showInspector = false

  let shouldCenterNotification = NotificationCenter.default
    .publisher(for: .shouldCenterMap)
    .receive(on: RunLoop.main)

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
    .frame(minWidth: 400, minHeight: 220)
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
    .toolbar {
      ToolbarItem {
        Toggle(isOn: $autoRefresh) {
          Label("Auto refresh", systemImage: "autostartstop")
            .foregroundStyle(autoRefresh ? Color.red : .primary)
        }
      }

      ToolbarItem {
        Button("Refresh", systemImage: "arrow.clockwise") {
          print("Refresh ISS location")
        }
      }

      ToolbarItem {
        Button("Center", systemImage: "scope") {
          centerMap()
        }
      }
    }
    .onMapCameraChange(frequency: .onEnd) { context in
      currentMapCamera = context.camera
    }
    .onReceive(shouldCenterNotification) { _ in
      centerMap()
    }
  }

  func centerMap() {
    guard let currentMapCamera else {
      return
    }
    let newMapCamera = MapCamera(
      centerCoordinate: location,
      distance: currentMapCamera.distance
    )
    position = MapCameraPosition.camera(newMapCamera)
  }
}

#Preview {
  ContentView()
    .frame(width: 400, height: 220)
}
