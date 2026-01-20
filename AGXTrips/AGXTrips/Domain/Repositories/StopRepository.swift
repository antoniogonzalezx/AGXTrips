//
//  StopRepository.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import Foundation

protocol StopRepository: Sendable {
    func fetchStops() async throws -> [Stop]
}
