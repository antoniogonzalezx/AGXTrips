//
//  DomainTests.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 22/1/26.
//

import Testing
import Foundation
import MapKit
@testable import AGXTrips

@Suite("Coordinate Tests")
struct CoordinateTests {
    
    @Test("CLLocationCoordinate2D conversion")
    func clLocationConversion() {
        let coordinate = Coordinate(latitude: 12.3456, longitude: 98.7654)
        let clCoordinate = coordinate.clLocationCoordinate2D
        
        #expect(clCoordinate.latitude == 12.3456)
        #expect(clCoordinate.longitude == 98.7654)
    }
    
    @Test("Coordinate equality")
    func coordinateEquality() {
        let coord1 = Coordinate(latitude: 12.3456, longitude: 98.7654)
        let coord2 = Coordinate(latitude: 12.3456, longitude: 98.7654)
        let coord3 = Coordinate(latitude: 0.0, longitude: 0.0)
        
        #expect(coord1 == coord2)
        #expect(coord1 != coord3)
    }
}

@Suite("Stop Tests")
struct StopTests {
    
    @Test("Stop initialization")
    func stopInit() {
        let stop = Stop(
            id: 1,
            tripId: 1,
            userName: "Antonio",
            address: "Valdepeñas",
            coordinate: Coordinate(latitude: 1.0, longitude: 2.0),
            stopTime: Date(),
            price: 1.5,
            isPaid: true
        )
        
        #expect(stop.id == 1)
        #expect(stop.tripId == 1)
        #expect(stop.userName == "Antonio")
        #expect(stop.price == 1.5)
        #expect(stop.isPaid == true)
    }
    
    @Test("Two stops with same data are equal")
    func stopEquality() {
        let stop1 = Stop(id: 1, tripId: 1, userName: "User", address: "Address", coordinate: Coordinate(latitude: 0, longitude: 0), stopTime: Date(), price: 1.0, isPaid: false)
        let stop2 = Stop(id: 1, tripId: 1, userName: "User", address: "Address", coordinate: Coordinate(latitude: 0, longitude: 0), stopTime: Date(), price: 1.0, isPaid: false)
        
        #expect(stop1 == stop2)
    }
}

@Suite("Trip tests")
struct TripTests {
    func makeTrip(
        id: String = UUID().uuidString,
        status: Trip.Status = .ongoing
    ) -> Trip {
        Trip(
            id: id,
            description: "Test trip",
            driverName: "Antonio",
            status: status,
            origin: Trip.Location(address: "Valdepeñas", coordinate: Coordinate(latitude: 40.0, longitude: -1.0)),
            destination: Trip.Location(address: "Barcelona", coordinate: Coordinate(latitude: 42.0, longitude: 3.0)),
            stops: [
                .init(id: 0, coordinate: .init(latitude: 1.0, longitude: 2.0))
            ],
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600)
        )
    }
    
    @Test("Trip initialization")
    func tripInit() {
        let id = "trip1"
        let trip = makeTrip(id: id)
        
        #expect(trip.id == id)
        #expect(trip.driverName == "Antonio")
        #expect(trip.status == .ongoing)
        #expect(trip.endTime > trip.startTime)
    }
    
    @Test("Status returns correct displayName", arguments: [
        (Trip.Status.ongoing, "Ongoing"),
        (Trip.Status.scheduled, "Scheduled"),
        (Trip.Status.finalized, "Finished"),
        (Trip.Status.cancelled, "Cancelled")
    ])
    func statusDisplayNames(status: Trip.Status, expectedDisplayName: String) {
        #expect(status.displayName == expectedDisplayName)
    }
    
    @Test("Two trips with same data are equal")
    func tripEquality() {
        let id = "tripEqual"
        let trip1 = makeTrip(id: id)
        let trip2 = makeTrip(id: id)
        
        #expect(trip1 == trip2)
        #expect(trip1.hashValue == trip2.hashValue)
    }
}
