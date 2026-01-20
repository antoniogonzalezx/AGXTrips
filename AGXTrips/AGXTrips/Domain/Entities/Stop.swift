//
//  Stop.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import Foundation

struct Stop: Identifiable, Hashable, Sendable {
    let id: Int
    let tripId: Int
    let userName: String
    let address: String
    let coordinate: Coordinate
    let stopTime: Date
    let price: Double
    let isPaid: Bool
}
