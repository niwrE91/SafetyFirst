//
//  RkiCountyDataResponse.swift
//  SafetyFirst
//
//  Created by Erwin Warkentin on 13.11.20.
//

import Foundation

struct RkiCountyDataResponse: Codable {
    var features: [Features]
}

extension RkiCountyDataResponse: Equatable {}

struct Features: Codable {
    var attributes: Attributes
}

extension Features: Equatable {}

struct Attributes: Codable {
    var cases7PerOnehundretK: Double
    var county: String
    var BlID: String

    enum CodingKeys: String, CodingKey{
        case cases7PerOnehundretK = "cases7_per_100k"
        case county
        case BlID = "BL_ID"
    }
}

extension Attributes: Equatable {}
