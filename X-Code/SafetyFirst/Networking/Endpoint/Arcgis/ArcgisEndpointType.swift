//
//  ArcgisEndpointType.swift
//  SafetyFirst
//
//  Created by Erwin Warkentin on 13.11.20.
//

import Foundation

protocol ArcgisEndpointType: EndPointType {}

extension ArcgisEndpointType {
    var baseURL: URL {
        let urlString = "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest"

        guard let url = URL(string: urlString) else {
            fatalError("URL string is not a valid url.")
        }

        return url
    }
}
