//
//  StopDetailView.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 21/1/26.
//

import SwiftUI

struct StopDetailView: View {
    let stop: Stop
    let dismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack {
                    Image(systemName: "figure.wave.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.green)
                    
                    Text(stop.userName)
                        .font(.title.weight(.semibold))
                    
                    Label(stop.address, systemImage: "location.fill")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .padding()
                
                HStack {
                    detailCard(
                        title: "Time",
                        value: stop.stopTime.formatted(date: .omitted, time: .shortened),
                        icon: "clock.fill"
                    )
                    
                    detailCard(
                        title: "Price",
                        value: "\(stop.price.formatted())€",
                        icon: "eurosign.circle.fill"
                    )
                    
                    detailCard(
                        title: "Status",
                        value: stop.isPaid ? "Paid" : "Pending",
                        color: stop.isPaid ? .green : .red,
                        icon: stop.isPaid ? "checkmark.square.fill" : "hourglass"
                    )
                }
                .padding(.horizontal)
            }
            .navigationTitle("Stop info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
    
    private func detailCard(title: String, value: String, color: Color = .gray, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
            
            Text(title.uppercased())
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title3.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    StopDetailView(
        stop: .init(
            id: 0,
            tripId: 1,
            userName: "Antonio González",
            address: "Valdepeñas, España",
            coordinate: .init(latitude: 0.0, longitude: 0.0),
            stopTime: Date() + 1000,
            price: 1.5,
            isPaid: false
        ), dismiss: {}
    )
}
