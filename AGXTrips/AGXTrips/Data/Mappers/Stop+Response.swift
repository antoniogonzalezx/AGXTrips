//
//  Stop+Response.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import Foundation

extension Stop {
    init?(from response: StopResponse) {
        let dateFormatter = ISO8601DateFormatter()
        
        guard let stopTime = dateFormatter.date(from: response.stopTime) else { return nil }
        
        self.id = response.id
        self.tripId = response.tripId
        self.userName = response.userName
        self.address = response.address
        self.coordinate = Coordinate(
            latitude: response.point.latitude,
            longitude: response.point.longitude
        )
        self.stopTime = stopTime
        self.price = response.price
        self.isPaid = response.paid
    }
}
