//
//  ContentView.swift
//  BounceGPS
//
//  Created by Jarrett Young on 12/21/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var isMenuOpen = false
    @State private var selectedLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 34.0454337, longitude: -118.2607808)
    @State private var pinLocked = false
    @State private var pinCoordinates: String = "LAT 34.0454, LON -118.2607"

    var body: some View {
        ZStack {
            // Map View
            MapView(selectedLocation: $selectedLocation, pinLocked: $pinLocked, pinCoordinates: $pinCoordinates)
                .edgesIgnoringSafeArea(.all)

            // Top Navigation Bar
            VStack {
                HStack {
                    // Menu Button
                    Button(action: {
                        isMenuOpen.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    // Logo
                    HStack(spacing: 4) {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("BOUNCE GPS")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 5)
                Spacer()
            }

            // Bottom Control Panel
            VStack {
                Spacer()
                VStack(spacing: 10) {
                    // Latitude and Longitude Section
                    HStack {
                        Text(pinCoordinates)
                            .font(.footnote)
                            .foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            LocationManager.shared.centerToUserLocation { location in
                                if let location = location {
                                    if pinLocked {
                                        // Only center the map on the blue location dot when the pin is locked
                                        NotificationCenter.default.post(name: .centerMapOnLocation, object: location)
                                    } else {
                                        // Move both the map and the pin to the blue location dot when unlocked
                                        selectedLocation = location
                                        NotificationCenter.default.post(name: .centerMapOnLocation, object: location)
                                    }
                                } else {
                                    print("Failed to fetch user location.")
                                }
                            }
                        }) {
                            Image(systemName: "location.north.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                    // Set Location Button
                    Button(action: {
                        pinLocked.toggle()
                    }) {
                        HStack {
                            Image(systemName: pinLocked ? "checkmark.circle" : "location.circle")
                                .foregroundColor(.white)
                            Text(pinLocked ? "LOCATION SET" : "SET LOCATION")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(pinLocked ? Color.green : Color.red)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()
            }

            // Side Menu Overlay
            if isMenuOpen {
                SideMenu(isMenuOpen: $isMenuOpen)
            }
        }
    }
}

extension Notification.Name {
    static let centerMapOnLocation = Notification.Name("centerMapOnLocation")
}
