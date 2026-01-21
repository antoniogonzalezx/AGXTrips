//
//  Trip+Response.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import Foundation

extension Trip {
    init?(from response: TripResponse) {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard
            let startTime = dateFormatter.date(from: response.startTime),
            let endTime = dateFormatter.date(from: response.endTime),
            let status = Status(rawValue: response.status)
        else { return nil }
        
        let validStops = response.stops.compactMap { stopResponse -> StopPoint? in
            guard
                let id = stopResponse.id,
                let point = stopResponse.point
            else { return nil }
            
            return StopPoint(
                id: id,
                coordinate: Coordinate(
                    latitude: point.latitude,
                    longitude: point.longitude
                )
            )
        }
        
        self.id = UUID().uuidString
        self.description = response.description
        self.driverName = response.driverName
        self.status = status
        self.origin = Location(
            address: response.origin.address,
            coordinate: Coordinate(
                latitude: response.origin.point.latitude,
                longitude: response.origin.point.longitude
            )
        )
        self.destination = Location(
            address: response.destination.address,
            coordinate: Coordinate(
                latitude: response.destination.point.latitude,
                longitude: response.destination.point.longitude
            )
        )
        self.stops = validStops
        self.startTime = startTime
        self.endTime = endTime
    }
}
