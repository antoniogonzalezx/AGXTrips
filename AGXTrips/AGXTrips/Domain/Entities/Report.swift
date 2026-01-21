//
//  Report.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 21/1/26.
//

import Foundation
import SwiftData

@Model
final class Report {
    var name: String
    var email: String
    var phone: String?
    var message: String
    var createdAt: Date
    
    init(name: String, email: String, phone: String? = nil, message: String, createdAt: Date) {
        self.name = name
        self.email = email
        self.phone = phone
        self.message = message
        self.createdAt = createdAt
    }
}
