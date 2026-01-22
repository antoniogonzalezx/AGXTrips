//
//  Mocks.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 22/1/26.
//

import Foundation

extension Trip {
    static func mock(
        id: String = "id",
        description: String = "Test Trip",
        driverName: String = "Test Driver",
        status: Trip.Status = .ongoing,
        stopsCount: Int = 2
    ) -> Trip {
        Trip(
            id: id,
            description: description,
            driverName: driverName,
            status: status,
            origin: Trip.Location(address: "Origin", coordinate: Coordinate(latitude: 1.0, longitude: 2.0)),
            destination: Trip.Location(address: "Destination", coordinate: Coordinate(latitude: 2.0, longitude: 2.0)),
            stops: (0..<stopsCount).map { i in
                Trip.StopPoint(id: i, coordinate: Coordinate(latitude: 1.0 + Double(i) * 0.01, longitude: 2.0))
            },
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600)
        )
    }
}

extension Stop {
    static func mock(id: Int = 1, tripId: Int = 1) -> Stop {
        Stop(
            id: id,
            tripId: tripId,
            userName: "Test User",
            address: "Test Address",
            coordinate: Coordinate(latitude: 1.0, longitude: 2.0),
            stopTime: Date(),
            price: 1.5,
            isPaid: true
        )
    }
}
