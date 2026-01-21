//
//  TripListView.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import SwiftUI
import MapKit

struct TripListView: View {
    @State var viewModel: TripListViewModel
    @State private var sheetDetent: PresentationDetent = .medium
    
    var body: some View {
        NavigationStack {
            ZStack {
                mapView
            }
        }
        .sheet(isPresented: .constant(true)) {
            tripListSheet
                .presentationDetents([.medium, .large], selection: $sheetDetent)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
        }
        .sheet(item: $viewModel.selectedStop) { stop in
            EmptyView()
        }
        .task {
            await viewModel.fetchTrips()
        }
        
    }
    
    private var mapView: some View {
        Map(position: $viewModel.mapCameraPosition) {
            if let selectedTrip = viewModel.selectedTrip {
                MapPolyline(coordinates: viewModel.routeCoordinates(for: selectedTrip))
                    .stroke(.green, lineWidth: 4)
                
                Marker(selectedTrip.origin.address, systemImage: "mappin.and.ellipse", coordinate: selectedTrip.origin.coordinate.clLocationCoordinate2D)
                    .tint(.blue)
                
                ForEach(viewModel.stops(for: selectedTrip)) { stop in
                    Marker(stop.address, systemImage: "mappin.circle", coordinate: stop.coordinate.clLocationCoordinate2D)
                        .tint(.green)
                }
                
                Marker(selectedTrip.destination.address, systemImage: "flag.checkered", coordinate: selectedTrip.destination.coordinate.clLocationCoordinate2D)
                    .tint(.red)
            }
        }
        .onChange(of: viewModel.selectedStopTag) { _, newValue in
            viewModel.handleStopSelection(newValue)
        }
    }
    
    private var tripList: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.trips) { trip in
                        TripCardView(
                            trip: trip,
                            isSelected: viewModel.selectedTrip?.id == trip.id
                        )
                        .onTapGesture {
                            viewModel.selectTrip(trip)
                            sheetDetent = .medium
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Trips")
        }
    }
    
    private var tripListSheet: some View {
        Group {
            if viewModel.isLoading {
                tripList
                    .redacted(reason: .placeholder)
            } else if let error = viewModel.error {
                Text(error.localizedDescription)
            } else {
                tripList
            }
        }
    }
}
