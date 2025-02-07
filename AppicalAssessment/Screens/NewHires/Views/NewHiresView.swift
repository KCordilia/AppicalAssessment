//
//  NewHiresView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 06/02/2025.
//

import SwiftUI

struct NewHiresView: View {
    @StateObject private var viewModel = NewHiresViewModel()

    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .success:
                VStack {
                    // Header
                    HStack {
                        Text("Recently assigned new hires")
                            .font(.title2)
                            .bold()
                        Spacer()
                        SortingPickerView(selectedOption: $viewModel.sortingOption)
                            .onChange(of: viewModel.sortingOption) {
                                viewModel.sortNewHires()
                            }
                    }
                    .padding(.horizontal)
                    
                    // List of new hires
                    List {
                        ForEach(viewModel.newHires, id: \.id) { newHire in
                            NewHireCellView(name: newHire.fullName, startDate: newHire.formattedStartDate, avatar: newHire.avatar)
                        }
                    }
                }

        case .error(let errorMessage):
            Text("Error: \(errorMessage)")
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            Text("No new hires found.")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
        .navigationTitle("Welcome your new hires")
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchNewHires()
                } catch {
                    // Handle errors if needed
                }
            }
        }
}
}
#Preview {
    NewHiresView()
}
