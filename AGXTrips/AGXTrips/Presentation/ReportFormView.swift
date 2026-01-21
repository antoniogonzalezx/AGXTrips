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
                
                TextField("Surname", text: $viewModel.surname)
                    .textContentType(.familyName)
                
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                TextField("Phone number", text: $viewModel.phone)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
            }
            
            Section("Message") {
                TextEditor(text: $viewModel.message)
                    .frame(minHeight: 120)
            }
            
            Section {
                Button {
                    viewModel.submit(context: modelContext)
                } label: {
                    HStack {
                        Spacer()
                        Text("Send report")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .disabled(!viewModel.isFormValid)
            }
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
