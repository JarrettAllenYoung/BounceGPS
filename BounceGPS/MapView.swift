//
//  MapView.swift
//  BounceGPS
//
//  Created by Jarrett Young on 12/21/24.
//

import SwiftUI
import MapLibre

struct MapView: UIViewRepresentable {
    @Binding var selectedLocation: CLLocationCoordinate2D
    @Binding var pinLocked: Bool
    @Binding var pinCoordinates: String

    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView(frame: .zero)
        mapView.styleURL = URL(string: "https://api.maptiler.com/maps/openstreetmap/style.json?key=2IXMPQAha0wjv708TjNx")
        mapView.setCenter(selectedLocation, zoomLevel: 16, animated: false) // Set initial zoom level
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        mapView.automaticallyAdjustsContentInset = false

        // Add initial pin
        let annotation = MLNPointAnnotation()
        annotation.coordinate = selectedLocation
        mapView.addAnnotation(annotation)

        // Listen for updates to center and zoom on the user's location
        NotificationCenter.default.addObserver(forName: .centerMapOnLocation, object: nil, queue: .main) { notification in
            if let location = notification.object as? CLLocationCoordinate2D {
                mapView.setCenter(location, zoomLevel: 16, animated: true)
            }
        }

        return mapView
    }

    func updateUIView(_ uiView: MLNMapView, context: Context) {
        if !pinLocked {
            // Allow the pin to follow the map center
            let center = uiView.centerCoordinate
            if let annotation = uiView.annotations?.first as? MLNPointAnnotation {
                annotation.coordinate = center
                selectedLocation = center
                pinCoordinates = String(format: "LAT %.4f, LON %.4f", center.latitude, center.longitude)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MLNMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MLNMapView, viewFor annotation: MLNAnnotation) -> UIView? {
            guard annotation is MLNPointAnnotation else { return nil }

            // Pin View
            let pinView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            pinView.layer.cornerRadius = 10
            pinView.backgroundColor = parent.pinLocked ? UIColor.green : UIColor.red
            pinView.layer.borderColor = UIColor.white.cgColor
            pinView.layer.borderWidth = 2
            return pinView
        }

        func mapView(_ mapView: MLNMapView, regionDidChangeAnimated animated: Bool) {
            guard !parent.pinLocked else { return }
            // Update the coordinates dynamically as the map moves
            let center = mapView.centerCoordinate
            parent.selectedLocation = center
            parent.pinCoordinates = String(format: "LAT %.4f, LON %.4f", center.latitude, center.longitude)
        }
    }
}
