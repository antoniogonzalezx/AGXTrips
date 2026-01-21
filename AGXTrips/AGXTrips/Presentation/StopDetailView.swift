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
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.red)
                    Text(stop.address)
                        .font(.title.weight(.semibold))
                    
                    Label(stop.userName.uppercased(), systemImage: "person.fill")
                        .font(.title3.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                .padding()
                
                Text(stop.isPaid ? "PAID" : "NOT PAID")
                    .font(.default.weight(.medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(stop.isPaid ? .green.opacity(0.1) : .red.opacity(0.1))
                    .foregroundStyle(stop.isPaid ? .green : .red)
                    .clipShape(Capsule())
                
                HStack {
                    detailLabel(stop.stopTime.formatted(date: .omitted, time: .shortened), systemImage: "clock")
                    
                    detailLabel("\(stop.price.formatted())€", systemImage: "creditcard.fill")
                }
                
                Spacer()
            }
            .navigationTitle("Stop")
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
    
    private func detailLabel(_ title: String, systemImage: String) -> some View {
        VStack {
            Label(title, systemImage: systemImage)
                .font(.title2.weight(.medium))
                .padding()
                .frame(maxWidth: .infinity, minHeight: 100)
        }
        .background(.thinMaterial.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 2)
        )
        
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
