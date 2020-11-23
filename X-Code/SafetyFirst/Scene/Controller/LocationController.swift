//
//  LocationController.swift
//  SafetyFirst
//
//  Created by Erwin Warkentin on 18.11.20.
//

import Foundation
import CoreLocation

class LocationController: NSObject {
    // CoreLocation
    fileprivate let locationManager: CLLocationManager

    enum LocationError {
        case unknown
        case denied
    }

    enum LocationStatus {
        case success(Location)
        case failed(LocationError)
    }

    private var didReceived: ((LocationStatus) -> ())?

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }

    func requestCurrentLocation(onReceivedLocationStatus: @escaping (LocationStatus) -> ()) {

        didReceived = onReceivedLocationStatus

        // check current location authorization
        locationManager.requestWhenInUseAuthorization()

        // chack if location service is enabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }

        if let currentLocation = locationManager.location {
            print(currentLocation)
        }
    }

    private func handleReceivedLocation(location: CLLocation) {

        let location = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print("Current Location: \(location)")

        self.didReceived?(.success(location))
    }
}

extension LocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .denied:
                print("User denied location access")
                didReceived?(.failed(.denied))
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Location access allowed. We are good to go")
            case .restricted:
                didReceived?(.failed(.denied))
                print("Location acces is restricted")
            @unknown default:
                print("Unkown case")
                didReceived?(.failed(.unknown))
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.first != nil {

            guard let location = locations.last else {
                print("Could not determinde current location")
                return
            }

            handleReceivedLocation(location: location)
        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Requesting current location failed: \(error)")

        guard let locationError = error as? CLError else { return }

        switch locationError.code {
            case .locationUnknown:
                print("Location not found. Waiting for new event")
            case .headingFailure:
                didReceived?(.failed(.unknown))
            case .denied:
                print("User denied access to location service")
                didReceived?(.failed(.denied))
            default:
                didReceived?(.failed(.unknown))
        }
    }
}
