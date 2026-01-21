//
//  ReportFormViewModel.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 21/1/26.
//

import SwiftUI
import SwiftData
import UserNotifications

@MainActor
@Observable
final class ReportFormViewModel {
    var name = ""
    var surname = ""
    var email = ""
    var phone = ""
    var message = ""
    
    var isSubmitted = false
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !surname.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@") &&
        !message.trimmingCharacters(in: .whitespaces).isEmpty &&
        message.count <= 200
    }
    
    func submit(context: ModelContext) {
        let report = Report(
            name: [
                name.trimmingCharacters(in: .whitespaces),
                surname.trimmingCharacters(in: .whitespaces)
            ]
                .joined(separator: " "),
            email: email.trimmingCharacters(in: .whitespaces),
            phone: phone.trimmingCharacters(in: .whitespaces),
            message: message,
            createdAt: Date()
        )
        
        context.insert(report)
        try? context.save()
        updateAppBadge(context: context)
        isSubmitted = true
    }
    
    // MARK: - Private
    
    private func updateAppBadge(context: ModelContext) {
        let descriptor = FetchDescriptor<Report>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { granted, _ in
            guard granted else { return }
            
            Task { @MainActor in
                UNUserNotificationCenter.current().setBadgeCount(count)
            }
        }
    }
}
