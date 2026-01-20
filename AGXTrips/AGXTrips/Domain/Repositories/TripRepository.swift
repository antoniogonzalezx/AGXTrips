//
//  TripRepository.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import Foundation

protocol TripRepository: Sendable {
    func fetchTrips() async throws -> [Trip]
}
