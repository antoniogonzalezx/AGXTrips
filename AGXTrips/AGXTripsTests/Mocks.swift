//
//  Mocks.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 22/1/26.
//

import Foundation
@testable import AGXTrips

@MainActor
final class TripRepositoryMock: TripRepository {
    var tripsToReturn: [Trip] = []
    var errorToThrow: Error?
    
    func fetchTrips() async throws -> [Trip] {
        if let error = await errorToThrow {
            throw error
        }
        return await tripsToReturn
    }
}

@MainActor
final class StopRepositoryMock: StopRepository {
    var stopsToReturn: [Stop] = []
    var errorToThrow: Error?
    
    func fetchStops() async throws -> [Stop] {
        if let error = await errorToThrow {
            throw error
        }
        return await stopsToReturn
    }
}
