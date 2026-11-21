import SwiftUI
import MapKit

public struct MapRouteView: UIViewRepresentable {
    public var startLocation: CLLocationCoordinate2D?
    public var destinationLocation: CLLocationCoordinate2D
    public var radiusMeters: Double
    public var destinationName: String
    public var onPointPicked: ((CLLocationCoordinate2D) -> Void)?

    public func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true

        let gesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(gesture)

        return mapView
    }

    public func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        uiView.removeAnnotations(uiView.annotations)

        // Destination Marker
        let destAnnotation = MKPointAnnotation()
        destAnnotation.coordinate = destinationLocation
        destAnnotation.title = "Destination: \(destinationName)"
        destAnnotation.subtitle = "End Point"
        uiView.addAnnotation(destAnnotation)

        // Target Radius Circle
        let circle = MKCircle(center: destinationLocation, radius: radiusMeters)
        uiView.addOverlay(circle)

        if let start = startLocation {
            // Start Marker
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = start
            startAnnotation.title = "Start: Your Location"
            startAnnotation.subtitle = "Start Point"
            uiView.addAnnotation(startAnnotation)

            // Polyline route connecting start and end
            let coords = [start, destinationLocation]
            let polyline = MKPolyline(coordinates: coords, count: 2)
            uiView.addOverlay(polyline)

            // Zoom bounds
            let rect = polyline.boundingMapRect
            let padding = UIEdgeInsets(top: 80, left: 80, bottom: 80, right: 80)
            uiView.setVisibleMapRect(rect, edgePadding: padding, animated: true)
        } else {
            let region = MKCoordinateRegion(center: destinationLocation, latitudinalMeters: radiusMeters * 3, longitudinalMeters: radiusMeters * 3)
            uiView.setRegion(region, animated: true)
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapRouteView

        init(_ parent: MapRouteView) {
            self.parent = parent
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let mapView = gesture.view as? MKMapView else { return }
            let point = gesture.location(in: mapView)
            let coord = mapView.convert(point, toCoordinateFrom: mapView)
            parent.onPointPicked?(coord)
        }

        public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor(red: 0.22, green: 0.74, blue: 0.97, alpha: 1.0)
                renderer.lineWidth = 5.0
                return renderer
            } else if let circle = overlay as? MKCircle {
                let renderer = MKCircleRenderer(circle: circle)
                renderer.strokeColor = UIColor(red: 0.22, green: 0.74, blue: 0.97, alpha: 0.8)
                renderer.fillColor = UIColor(red: 0.22, green: 0.74, blue: 0.97, alpha: 0.2)
                renderer.lineWidth = 2.0
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }
            let identifier = "MapPointMarker"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = true
            } else {
                view?.annotation = annotation
            }

            if annotation.title??.contains("Start") == true {
                view?.markerTintColor = UIColor(red: 0.01, green: 0.52, blue: 0.78, alpha: 1.0)
                view?.glyphImage = UIImage(systemName: "location.fill")
            } else {
                view?.markerTintColor = UIColor(red: 0.86, green: 0.15, blue: 0.15, alpha: 1.0)
                view?.glyphImage = UIImage(systemName: "mappin.and.ellipse")
            }
            return view
        }
    }
}
