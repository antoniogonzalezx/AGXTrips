//
//  AGXTripsApp.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import SwiftUI

@main
struct AGXTripsApp: App {
    private let factory = DependencyFactory()
    
    var body: some Scene {
        WindowGroup {
            TripListView(
                viewModel: TripListViewModel(
                    tripRepository: factory.tripRepository,
                    stopRepository: factory.stopRepository
                )
            )
        }
    }
}
