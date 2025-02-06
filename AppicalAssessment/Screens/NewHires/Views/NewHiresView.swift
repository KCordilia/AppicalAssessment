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
            case .success(let newHires):
                HStack {
                    Text("Recently assigned new hires")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button(action: {
                        viewModel.toggleSortOrder()
                    }) {
                        Image(systemName: viewModel.isAscending ? "arrow.up" : "arrow.down")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                List {
                    ForEach(newHires, id: \.id) { newHire in
                        Text(newHire.firstName)
                        HStack {
                            Text("First day")
                            Text(newHire.formattedStartDate)
                        }
                    }
                }
            case .error:
                Circle()
            case .empty:
                Rectangle()
            }
        }
        .onAppear {
            Task {
                try await viewModel.fetchNewHires()
            }
        }
    }
}

#Preview {
    NewHiresView()
}
