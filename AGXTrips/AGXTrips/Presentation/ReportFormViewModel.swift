//
//  ReportFormViewModel.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 21/1/26.
//

import SwiftUI
import SwiftData

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
        !message.trimmingCharacters(in: .whitespaces).isEmpty
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
        isSubmitted = true
    }
}
