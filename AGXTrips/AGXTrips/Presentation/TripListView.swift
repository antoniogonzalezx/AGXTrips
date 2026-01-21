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
    @State private var showReportForm = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                mapView
                    .navigationTitle("AGXTrips")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showReportForm = true
                            } label: {
                                Image(systemName: "exclamationmark.bubble")
                            }
                        }
                    }
                    .navigationDestination(isPresented: $showReportForm) {
                        ReportFormView()
                    }
            }
        }
        .sheet(isPresented: .constant(!showReportForm)) {
            sheetContent
                .presentationDetents(sheetDetentOptions, selection: $sheetDetent)
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .interactiveDismissDisabled()
        }
        .task {
            await viewModel.fetchTrips()
        }
        
    }
    
    private var mapView: some View {
        Map(position: $viewModel.mapCameraPosition, selection: $viewModel.selectedStopTag) {
            if let selectedTrip = viewModel.selectedTrip {
                MapPolyline(coordinates: viewModel.routeCoordinates(for: selectedTrip))
                    .stroke(Gradient(colors: [.cyan, .blue, .purple]), lineWidth: 6)
                
                Marker(selectedTrip.origin.address, systemImage: "mappin.and.ellipse", coordinate: selectedTrip.origin.coordinate.clLocationCoordinate2D)
                    .tint(.blue)
                
                ForEach(viewModel.stops(for: selectedTrip)) { stop in
                    Marker(stop.address, systemImage: "mappin", coordinate: stop.coordinate.clLocationCoordinate2D)
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
                            sheetDetent = .fraction(0.25)
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
    
    @ViewBuilder
    private var sheetContent: some View {
        if let stop = viewModel.selectedStop {
            StopDetailView(stop: stop) {
                viewModel.selectedStop = nil
                viewModel.selectedStopTag = nil
            }
        } else {
            tripListSheet
        }
    }
    
    private var sheetDetentOptions: Set<PresentationDetent> {
        if viewModel.selectedStop != nil {
            return [.medium]
        } else {
            return [.fraction(0.25), .medium, .large]
        }
    }
}
