//
//  RkiLandkreisDaten.swift
//  SafetyFirst
//
//  Created by Erwin Warkentin on 13.11.20.
//

import Foundation

struct RkiCountyDataEndpoint: ArcgisEndpointType {
    typealias Response = RkiCountyDataResponse

    private let long: Double
    private let lat: Double

    init(longitude: Double, latitude: Double) {
        self.long = longitude
        self.lat = latitude
    }

    var path: String {
        "services/RKI_Landkreisdaten/FeatureServer/0/query"
    }

    var httpMethod: HTTPMethod {
        .GET
    }

    var httpBody: HTTPBody?

    var httpHeaders: HTTPHeaders?

    var urlParameters: URLParameters? {
            ["outFields": "BL_ID,cases7_per_100k,GEN,county",
             "geometry": "\(long),\(lat)",
             "geometryType": "esriGeometryPoint",
             "returnGeometry": "false",
             "inSR": "4326",
             "spatialRel": "esriSpatialRelWithin",
             "f": "json"]
    }
}
