//
//  ViewModelTests.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 22/1/26.
//

import Testing
import Foundation
@testable import AGXTrips

// MARK: - ReportFormViewModel tests

@Suite("ReportFormViewModel Tests")
struct ReportFormViewModelTests {
    
    @Test("Form is invalid when fields are empty")
    @MainActor
    func formInvalidWhenEmpty() {
        let viewModel = ReportFormViewModel()
        
        #expect(!viewModel.isFormValid)
    }
    
    @Test("Form is invalid with invalid email")
    @MainActor
    func formInvalidWithBadEmail() {
        let viewModel = ReportFormViewModel()
        viewModel.name = "Name"
        viewModel.surname = "Surname"
        viewModel.email = "invalid-email"
        viewModel.message = "Test message"
        
        #expect(!viewModel.isFormValid)
    }
    
    @Test("Form is valid with all required fields")
    @MainActor
    func formValidWithRequiredFields() {
        let viewModel = ReportFormViewModel()
        viewModel.name = "Name"
        viewModel.surname = "Surname"
        viewModel.email = "valid@example.com"
        viewModel.message = "Test message"
        
        #expect(viewModel.isFormValid)
    }
    
    @Test("Form is invalid with a long message (> 200 characters)")
    @MainActor
    func formInvalidWithLongMessage() {
        let viewModel = ReportFormViewModel()
        viewModel.name = "Name"
        viewModel.surname = "Surname"
        viewModel.email = "valid@example.com"
        viewModel.message = "Text with more than 200 characters to test the character count functionality. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        
        #expect(!viewModel.isFormValid)
    }
}

// MARK: - TripListViewModel tests

@Suite("TripListViewModel Tests")
@MainActor
struct TripListViewModelTests {
    
    @Test("Successfully fetches trips and stops")
    func fetchTripsAndStopsSuccess() async {
        let tripRepo = TripRepositoryMock()
        let stopRepo = StopRepositoryMock()
        
        tripRepo.tripsToReturn = [Trip.mock()]
        stopRepo.stopsToReturn = [Stop.mock()]
        
        let viewModel = TripListViewModel(tripRepository: tripRepo, stopRepository: stopRepo)
        
        await viewModel.fetchTrips()
        
        #expect(viewModel.trips.count == 1)
        #expect(viewModel.stops.count == 1)
        #expect(viewModel.error == nil)
        #expect(!viewModel.isLoading)
    }
    
    @Test("Selecting a trip updates selection state")
    func selectTrip() async {
        let tripRepo = TripRepositoryMock()
        let stopRepo = StopRepositoryMock()
        let trip = Trip.mock()
        
        tripRepo.tripsToReturn = [trip]
        
        let viewModel = TripListViewModel(tripRepository: tripRepo, stopRepository: stopRepo)
        await viewModel.fetchTrips()
        
        viewModel.selectTrip(trip)
        
        #expect(viewModel.selectedTrip?.id == trip.id)
        #expect(viewModel.selectedStop == nil)
    }
    
    @Test("Clearing selection resets state")
    func clearSelection() async {
        let tripRepo = TripRepositoryMock()
        let stopRepo = StopRepositoryMock()
        let trip = Trip.mock()
        
        tripRepo.tripsToReturn = [trip]
        
        let viewModel = TripListViewModel(tripRepository: tripRepo, stopRepository: stopRepo)
        await viewModel.fetchTrips()
        
        viewModel.selectTrip(trip)
        viewModel.clearTripSelection()
        
        #expect(viewModel.selectedTrip == nil)
        #expect(viewModel.selectedStop == nil)
    }
    
    @Test("Handle stop selection finds correct stop")
    func handleStopSelection() async {
        let tripRepo = TripRepositoryMock()
        let stopRepo = StopRepositoryMock()
        let stop = Stop.mock(id: 5)
        
        stopRepo.stopsToReturn = [stop]
        
        let viewModel = TripListViewModel(tripRepository: tripRepo, stopRepository: stopRepo)
        await viewModel.fetchTrips()
        
        viewModel.handleStopSelection(5)
        
        #expect(viewModel.selectedStop?.id == 5)
    }
    
    @Test("Handle stop selection with nil clears selection")
    func handleNilStopSelection() async {
        let tripRepo = TripRepositoryMock()
        let stopRepo = StopRepositoryMock()
        let stop = Stop.mock(id: 5)
        
        stopRepo.stopsToReturn = [stop]
        
        let viewModel = TripListViewModel(tripRepository: tripRepo, stopRepository: stopRepo)
        await viewModel.fetchTrips()
        
        viewModel.handleStopSelection(5)
        viewModel.handleStopSelection(nil)
        
        #expect(viewModel.selectedStop == nil)
    }
    
    @Test("Filters stops for a trip correctly")
    func stopsForTrip() async {
        let tripRepo = TripRepositoryMock()
        let stopRepo = StopRepositoryMock()
        
        let trip = Trip.mock(stopsCount: 2)
        tripRepo.tripsToReturn = [trip]
        
        let stops = [
            Stop.mock(id: 0, tripId: 1),
            Stop.mock(id: 1, tripId: 1),
            Stop.mock(id: 2, tripId: 2),
        ]
        stopRepo.stopsToReturn = stops
        
        let viewModel = TripListViewModel(tripRepository: tripRepo, stopRepository: stopRepo)
        await viewModel.fetchTrips()
        
        let filteredStops = viewModel.stops(for: trip)
        
        #expect(filteredStops.count == 2)
        #expect(filteredStops.allSatisfy { $0.id == 0 || $0.id == 1 })
    }
}
