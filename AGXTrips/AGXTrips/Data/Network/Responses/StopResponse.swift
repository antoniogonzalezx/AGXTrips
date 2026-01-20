//
//  StopResponse.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import Foundation

struct StopResponse: Decodable, Sendable {
    let id: Int
    let price: Double
    let address: String
    let tripId: Int
    let paid: Bool
    let stopTime: String
    let point: PointResponse
    let userName: String
}
