//
//  TripCardView.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import SwiftUI

struct TripCardView: View {
    let trip: Trip
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(trip.description)
                    .font(.title2.weight(.bold))
                
                Spacer()
                
                Text(trip.status.displayName.uppercased())
                    .font(.caption.weight(.medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(trip.status.color.opacity(0.2))
                    .foregroundStyle(trip.status.color)
                    .clipShape(Capsule())
            }
            
            HStack {
                Label(trip.driverName, systemImage: "steeringwheel")
                
                Spacer()
                
                Label("\(trip.startTime.formatted(date: .omitted, time: .shortened)) – \(trip.endTime.formatted(date: .omitted, time: .shortened))", systemImage: "clock")
            }
            .font(.headline)
            .foregroundStyle(.secondary)
            
            Divider()
            
            HStack {
                Label("\(trip.origin.address) → \(trip.destination.address)", systemImage: "point.topleft.down.to.point.bottomright.curvepath")
                
                Spacer()
                
                Label("\(trip.stops.count) stops", systemImage: "map")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(isSelected ? Color.accentColor.opacity(0.1) : Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.accentColor : Color(.separator).opacity(0.7), lineWidth: 2)
        )
    }
}

#Preview("Trip card (No selection)") {
    TripCardView(
        trip: .init(
            id: "",
            description: "Barcelona a Martorell",
            driverName: "Antonio González",
            status: .ongoing,
            origin: .init(address: "Barcelona", coordinate: .init(latitude: 40.12345, longitude: 2.12345)),
            destination: .init(address: "Martorell", coordinate: .init(latitude: 40.83728, longitude: 2.23456)),
            stops: [
                .init(id: 0, coordinate: .init(latitude: 40.23456, longitude: 2.23456)),
                .init(id: 1, coordinate: .init(latitude: 40.34567, longitude: 2.34567))
            ],
            startTime: Date() - 1000,
            endTime: Date() + 1000
        ),
        isSelected: false
    )
}

#Preview("Trip card (Selected)") {
    TripCardView(
        trip: .init(
            id: "",
            description: "Barcelona a Martorell",
            driverName: "Antonio González",
            status: .ongoing,
            origin: .init(address: "Barcelona", coordinate: .init(latitude: 40.12345, longitude: 2.12345)),
            destination: .init(address: "Martorell", coordinate: .init(latitude: 40.83728, longitude: 2.23456)),
            stops: [
                .init(id: 0, coordinate: .init(latitude: 40.23456, longitude: 2.23456)),
                .init(id: 1, coordinate: .init(latitude: 40.34567, longitude: 2.34567))
            ],
            startTime: Date() - 1000,
            endTime: Date() + 1000
        ),
        isSelected: true
    )
}
