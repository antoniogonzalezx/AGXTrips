//
//  TripListView.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import SwiftUI
import MapKit
import SwiftData

struct TripListView: View {
    @State var viewModel: TripListViewModel
    @State private var showReportForm = false
    @Query private var reports: [Report]
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.error {
                errorView(error.localizedDescription) {
                    await viewModel.fetchTrips()
                }
            } else {
                VStack {
                    mapView
                        .frame(height: 200)

                    tripList
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showReportForm = true
                        } label: {
                            Image(systemName: "exclamationmark.bubble")
                        }
                        .badge(reports.count)
                        .accessibilityLabel("Report an issue")
                        .accessibilityHint("\(reports.count) reports submitted")
                    }
                }
                .navigationDestination(isPresented: $showReportForm) {
                    ReportFormView()
                }
                .refreshable {
                    await viewModel.fetchTrips()
                }
            }
        }
        .sheet(item: $viewModel.selectedStop, content: { stop in
            StopDetailView(stop: stop) {
                viewModel.handleStopSelection(nil)
            }
            .presentationDetents([.medium])
        })
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
                    .tint(.gray)
                
                ForEach(viewModel.stops(for: selectedTrip)) { stop in
                    Marker([stop.address, stop.userName].joined(separator: " - "), systemImage: "mappin", coordinate: stop.coordinate.clLocationCoordinate2D)
                        .tint(.blue)
                }
                
                Marker(selectedTrip.destination.address, systemImage: "flag.checkered", coordinate: selectedTrip.destination.coordinate.clLocationCoordinate2D)
                    .tint(.red)
            }
        }
        .accessibilityLabel("Trips map")
        .accessibilityElement(children: .ignore)
        .accessibilityHint(viewModel.selectedTrip != nil ? "Showing route for \(viewModel.selectedTrip!.description)" : "Select a trip to view its route")
        .onChange(of: viewModel.selectedStopTag) { _, newValue in
            viewModel.handleStopSelection(newValue)
        }
    }
    
    private var tripList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                Text("Available trips")
                    .font(.title.bold())
                    .accessibilityAddTraits(.isHeader)
                
                ForEach(viewModel.trips) { trip in
                    TripCardView(
                        trip: trip,
                        isSelected: viewModel.selectedTrip?.id == trip.id
                    )
                    .onTapGesture {
                        viewModel.selectTrip(trip)
                    }
                }
            }
            .padding()
        }
    }
    
    private var loadingView: some View {
        VStack {
            Image("")
                .frame(height: 200)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    Text("Available trips")
                        .font(.title.bold())
                    
                    ForEach(0..<10) { _ in
                        TripCardView(trip: .mock(status: .finalized), isSelected: false)
                    }
                }
                .padding()
            }
        }
        .redacted(reason: .placeholder)
    }
    
    private func errorView(_ message: String, retryAction: @escaping () async -> Void) -> some View {
        ContentUnavailableView(label: {
            Label("Error", systemImage: "exclamationmark.triangle")
        }, description: {
            Text(message)
        }, actions: {
            Button {
                Task {
                    await retryAction()
                }
            } label: {
                Text("Retry")
                    .fontWeight(.bold)
            }
            .buttonStyle(.borderedProminent)
        })
    }
}
