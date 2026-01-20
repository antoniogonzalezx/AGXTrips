//
//  Trip.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import Foundation
import CoreLocation

struct Trip: Identifiable, Hashable, Sendable {
    let id: String
    let description: String
    let driverName: String
    let status: Status
    let origin: Location
    let destination: Location
    let stops: [StopPoint]
    let route: [Coordinate]
    let startTime: Date
    let endTime: Date
    
    enum Status: String, Hashable, Sendable {
        case ongoing
        case scheduled
        case finalized
        case cancelled
    }
    
    struct Location: Hashable, Sendable {
        let address: String
        let coordinate: Coordinate
    }
    
    struct StopPoint: Identifiable, Hashable, Sendable {
        let id: Int
        let coordinate: Coordinate
    }
}
