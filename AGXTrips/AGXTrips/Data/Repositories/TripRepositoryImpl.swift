//
//  TripRepositoryImpl.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import Foundation

final class TripRepositoryImpl: TripRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchTrips() async throws -> [Trip] {
        let response: [TripResponse] = try await apiClient.request(.trips)
        return response.compactMap(Trip.init)
    }
}
