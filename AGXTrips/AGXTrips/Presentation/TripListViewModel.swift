//
//  TripListViewModel.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import SwiftUI
import MapKit

@MainActor
@Observable
final class TripListViewModel {
    private let tripRepository: TripRepository
    private let stopRepository: StopRepository
    
    private(set) var trips: [Trip] = []
    private(set) var stops: [Stop] = []
    private(set) var isLoading: Bool = false
    private(set) var error: Error?
    
    var selectedTrip: Trip?
    var selectedStop: Stop?
    var selectedStopTag: Int?
    var mapCameraPosition: MapCameraPosition = .automatic
    
    init(tripRepository: TripRepository, stopRepository: StopRepository) {
        self.tripRepository = tripRepository
        self.stopRepository = stopRepository
    }
    
    func fetchTrips() async {
        isLoading = true
        error = nil
        
        do {
            async let fetchedTrips = self.tripRepository.fetchTrips()
            async let fetchedStops = self.stopRepository.fetchStops()
            
            let (tripsData, stopsData) = try await (fetchedTrips, fetchedStops)
            
            trips = tripsData
            stops = stopsData
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func selectTrip(_ trip: Trip) {
        selectedTrip = trip
        selectedStop = nil
        selectedStopTag = nil
        centerMap(on: trip)
    }
    
    func clearTripSelection() {
        selectedTrip = nil
        selectedStop = nil
        selectedStopTag = nil
    }
    
    func handleStopSelection(_ stopId: Int?) {
        selectedStop = nil
        
        guard let stopId else {
            return
        }
        
        if let stop = stops.first(where: { $0.id == stopId }) {
            selectedStop = stop
        }
    }
    
    func stops(for trip: Trip) -> [Stop] {
        let tripStopIds = Set(trip.stops.map(\.id))
        return stops.filter { tripStopIds.contains($0.id) }
    }
    
    func routeCoordinates(for trip: Trip) -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        
        coordinates.append(trip.origin.coordinate.clLocationCoordinate2D)
        
        for stop in trip.stops {
            coordinates.append(stop.coordinate.clLocationCoordinate2D)
        }
        
        coordinates.append(trip.destination.coordinate.clLocationCoordinate2D)
        
        return coordinates
    }
    
    // MARK: - Private

    private func centerMap(on trip: Trip) {
        let coordinates = routeCoordinates(for: trip)
        
        guard !coordinates.isEmpty else { return }
        
        let minLatitude = coordinates.map(\.latitude).min()!
        let maxLatitude = coordinates.map(\.latitude).max()!
        let minLongitude = coordinates.map(\.longitude).min()!
        let maxLongitude = coordinates.map(\.longitude).max()!
        
        let center = CLLocationCoordinate2D(
            latitude: (minLatitude + maxLatitude) / 2,
            longitude: (minLongitude + maxLongitude) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLatitude - minLatitude) * 1.5,
            longitudeDelta: (maxLongitude - minLongitude) * 1.5
        )
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        withAnimation(.easeInOut(duration: 0.5)) {
            mapCameraPosition = .region(region)
        }
    }
}
