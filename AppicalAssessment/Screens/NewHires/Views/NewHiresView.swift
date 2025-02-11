//
//  NewHiresView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 06/02/2025.
//

import SwiftUI

struct NewHiresView: View {
    let newHires: [NewHire]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack {
//                switch viewModel.viewState {
//                case .loading:
//                    ProgressView()
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                case .success:
//                    VStack(alignment: .leading) {
//                        Text("Welcome your new hires")
//                            .padding(.horizontal)
//                            .padding(.vertical, 0)
//                            .font(.title3)
//                            .bold()
//                        // List of new hires
//                        List {
//                            ForEach(viewModel.newHires, id: \.id) { newHire in
//                                NewHireCellView(name: newHire.fullName, startDate: newHire.formattedStartDate, avatar: newHire.avatar)
//                                    .buttonStyle(.plain)
//                            }
//                        }
//                        .padding(.top, 0)
//                        .listStyle(.insetGrouped)
//
//                    }
//                    .background(Color(.systemGroupedBackground))
//
//                case .error(let errorMessage):
//                    Text("Error: \(errorMessage)")
//                        .foregroundColor(.red)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//
//                case .empty:
//                    Text("No new hires found.")
//                        .foregroundColor(.gray)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                }
            }
            .onAppear {
//                Task {
//                    do {
//                        try await viewModel.fetchNewHires()
//                    } catch {
//                        // Handle errors if needed
//                    }
//                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .bold))
                }
                .tint(.white)
            }
            ToolbarItem(placement: .principal) {
                Text("Recently assigned new hires")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .bold))
            }
//            ToolbarItem(placement: .topBarTrailing) {
//                SortingPickerView(selectedOption: $viewModel.sortingOption)
//                    .onChange(of: viewModel.sortingOption) {
//                        viewModel.sortNewHires()
//                    }
//            }
        }
        .toolbarBackground(Color("primary"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
#Preview {
    NewHiresView(newHires: [])
}
