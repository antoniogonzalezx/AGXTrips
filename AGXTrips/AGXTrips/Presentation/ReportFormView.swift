//
//  ReportFormView.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 21/1/26.
//

import SwiftUI
import SwiftData

struct ReportFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel = ReportFormViewModel()
    
    var body: some View {
        Form {
            Section("Personal information") {
                TextField("Name", text: $viewModel.name)
                    .textContentType(.givenName)
                    .accessibilityLabel("Name")
                    .accessibilityHint("Enter your first name")
                
                TextField("Surname", text: $viewModel.surname)
                    .textContentType(.familyName)
                    .accessibilityLabel("Surname")
                    .accessibilityHint("Enter your last name")
                
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .accessibilityLabel("Email address")
                    .accessibilityHint("Enter a valid email address")
                
                TextField("Phone number", text: $viewModel.phone)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
                    .accessibilityLabel("Phone number, optional")
                    .accessibilityHint("Enter your phone number if you want to be contacted by phone")
            }
            
            Section("Message") {
                TextField("Max. 200 characters", text: $viewModel.message, axis: .vertical)
                    .lineLimit(5, reservesSpace: true)
                    .accessibilityLabel("Issue description")
                    .accessibilityHint("Describe the issue in up to 200 characters")
            }
            
            Section {
                Button {
                    viewModel.submit(context: modelContext)
                } label: {
                    Text("Send report")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .disabled(!viewModel.isFormValid)
                .accessibilityLabel("Send report")
            }
            .foregroundStyle(.blue)
        }
        .navigationTitle("Report issue")
        .alert("Report sent", isPresented: $viewModel.isSubmitted) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your report has been sent. Thank you!")
        }
    }
}
