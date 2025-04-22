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
  @Environment(AppState.self) var appState: AppState

  @State private var position = MapCameraPosition.automatic
  @State private var currentMapCamera: MapCamera?
  @State private var showInspector = false

  let shouldCenterNotification = NotificationCenter.default
    .publisher(for: .shouldCenterMap)
    .receive(on: RunLoop.main)

  var body: some View {
    Map(position: $position) {
      annotation
    }
    .mapControlVisibility(.hidden)
    .frame(minWidth: 400, minHeight: 400)
    .onAppear(perform: setInitialCameraPosition)
    .onMapCameraChange(frequency: .onEnd) { context in
      currentMapCamera = context.camera
    }
    .onReceive(shouldCenterNotification) { _ in
      centerMap()
    }
    .onChange(of: appState.issLocation?.latitude) {
      if !position.positionedByUser {
        centerMap()
      }
    }
    .inspector(isPresented: $showInspector) {
      InspectorView()
    }
    .toolbar {
      Toolbar()
    }
  }

  var annotation: some MapContent {
    Annotation("ISS", coordinate: appState.currentISSCoordinate) {
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

  private func setInitialCameraPosition() {
    position = .camera(
      MapCamera(
        centerCoordinate: appState.currentISSCoordinate,
        distance: 40_000_000
      )
    )
  }

  private func centerMap() {
    guard let currentMapCamera else {
      return
    }
    let newMapCamera = MapCamera(
      centerCoordinate: appState.currentISSCoordinate,
      distance: currentMapCamera.distance
    )
    position = MapCameraPosition.camera(newMapCamera)
  }
}

#Preview {
  ContentView()
    .frame(width: 400, height: 220)
    .environment(AppState())
}
