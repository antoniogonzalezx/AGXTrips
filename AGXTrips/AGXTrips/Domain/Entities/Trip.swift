//
//  Trip.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import Foundation
import CoreLocation
import SwiftUI

struct Trip: Identifiable, Hashable, Sendable {
    let id: String
    let description: String
    let driverName: String
    let status: Status
    let origin: Location
    let destination: Location
    let stops: [StopPoint]
    let startTime: Date
    let endTime: Date
    
    enum Status: String, Hashable, Sendable {
        case ongoing
        case scheduled
        case finalized
        case cancelled
        
        var displayName: String {
            switch self {
            case .ongoing: "Ongoing"
            case .scheduled: "Scheduled"
            case .finalized: "Finished"
            case .cancelled: "Cancelled"
            }
        }
        
        var color: Color {
            switch self {
            case .ongoing: return .green
            case .scheduled: return .blue
            case .finalized: return .gray
            case .cancelled: return .red
            }
        }
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
