//
//  DependencyFactory.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import SwiftUI

final class DependencyFactory: Sendable {
    let tripRepository: TripRepository
    let stopRepository: StopRepository
    
    init(apiClient: APIClient = APIClient()) {
        self.tripRepository = TripRepositoryImpl(apiClient: apiClient)
        self.stopRepository = StopRepositoryImpl(apiClient: apiClient)
    }
}
