//
//  RkiOverviewController.swift
//  SafetyFirst
//
//  Created by Erwin Warkentin on 15.11.20.
//

import Foundation

//Controller errors
enum RkiCountyDataError: Equatable, Error {
    case networkError(message: String)
    case federalStateError(message: String)
    case unknownLoactionError(message: String)
    case locationDeniedError(message: String)
}

//Controller phases
enum RkiCountyDataPhase: Equatable {
    case phase1(Attributes)
    case phase2(Attributes)
    case phase3(Attributes)
    case phase4(Attributes)
}

//Controller states
enum RkiCountyDataState: Equatable {
    case idle
    case loading
    case success(RkiCountyDataPhase)
    case failed(RkiCountyDataError)
}

class RkiCountyDataController {

    var locationController = LocationController()

    // Public properties
    /// State oberver closure. Set this closure to observe state changes
    var didReceiveState: ((RkiCountyDataState) -> Void)?

    // Private properties
    private let networkManager: NetworkManaging
    private var state: RkiCountyDataState {
        didSet {
            DispatchQueue.main.async {
                self.didReceiveState?(self.state)
            }
        }
    }

    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
        self.state = .idle
    }

    /// Get all RKI Data for the current position. You need the didReceiveState closure in combination with this method to receive the Data.
    func getRkiData() {
        state = .loading

        locationController.requestCurrentLocation { (result) in
            switch result {
                case .success(let location):
                    self.requestRkiData(long: location.longitude, lat: location.latitude)
                case .failed(let error):
                    switch error {
                        case .denied:
                            self.state = .failed(.locationDeniedError(message: NSLocalizedString("label_txt_error_deniedLocation", comment: "please turn on location")))
                        case .unknown:
                            self.state = .failed(.unknownLoactionError(message: NSLocalizedString("label_txt_error_unknown", comment: "unknown error, please try later")))
                    }
            }
        }
    }

    private func requestRkiData(long: Double, lat: Double) {
        let rkiCountyDataEndpoint = RkiCountyDataEndpoint(longitude: long, latitude: lat)

        networkManager.request(for: rkiCountyDataEndpoint) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
                case .failure:
                    self.state = .failed(.networkError(message: NSLocalizedString("label_txt_error_unknown", comment: "unknown error, please try later")))

                case .success(let rkiData):
                    guard let attributes = rkiData.features.first?.attributes else {
                        self.state = .failed(.networkError(message: NSLocalizedString("label_txt_error_country", comment: "wrong country")))
                        return
                    }

                    // Only the federal state of Bavaria is allowed with id 9
                    if attributes.BlID != "9" {
                        self.state = .failed(.federalStateError(message: NSLocalizedString("label_txt_error_federalState", comment: "only in federal state of Bavaria")))
                    }
                    else {
                        // check in what phase the current county lokation is
                        if 0..<35 ~= attributes.cases7PerOnehundretK {
                            self.state = .success(.phase1(attributes))
                        }
                        else if 35..<50 ~= attributes.cases7PerOnehundretK  {
                            self.state = .success(.phase2(attributes))
                        }
                        else if 50..<100 ~= attributes.cases7PerOnehundretK {
                            self.state = .success(.phase3(attributes))
                        }
                        else if attributes.cases7PerOnehundretK > 100 {
                            self.state = .success(.phase4(attributes))
                        }
                    }
            }
        }
    }
}
