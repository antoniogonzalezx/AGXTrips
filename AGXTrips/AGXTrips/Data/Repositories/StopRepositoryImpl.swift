//
//  StopRepositoryImpl.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import Foundation

final class StopRepositoryImpl: StopRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchStops() async throws -> [Stop] {
        let response: [StopResponse] = try await apiClient.request(.stops)
        return response.compactMap(Stop.init)
    }
}
