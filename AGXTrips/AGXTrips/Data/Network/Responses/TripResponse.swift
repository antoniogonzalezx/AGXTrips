//
//  TripResponse.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import Foundation

struct TripResponse: Decodable, Sendable {
    let description: String
    let driverName: String
    let status: String
    let origin: LocationResponse
    let destination: LocationResponse
    let stops: [StopPointResponse]
    let startTime: String
    let endTime: String
}

struct LocationResponse: Decodable, Sendable {
    let address: String
    let point: PointResponse
}

struct PointResponse: Decodable, Sendable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "_latitude"
        case longitude = "_longitude"
    }
}

struct StopPointResponse: Decodable, Sendable {
    let id: Int?
    let point: PointResponse?
}
