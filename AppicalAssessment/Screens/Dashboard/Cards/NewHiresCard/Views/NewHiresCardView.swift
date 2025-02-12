//
//  NewHiresCardView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 10/02/2025.
//

import SwiftUI
import SwiftData

struct NewHiresCardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: NewHiresViewModel

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: NewHiresViewModel(modelContext: modelContext))
    }

    var body: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .success(let newHires):
            NavigationLink(destination: NewHiresView(newHires: newHires)) {
                CardView(icon: "person", title: "Recently assigned new hires") {
                    HStack(spacing: 24) {
                        Text("\(newHires.count)")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(Color("primary"))
                        OverlappingAvatarsView(avatarURLs: newHires.map { $0.avatar })
                        Spacer()
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("New hires started this month")
                            .font(.system(size: 14))
                            .foregroundColor(Color.gray)
                        Text("Send them a message to make them feel welcome")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                    }
                }
            }
        case .error(let error):
            ErrorView(error: error) {
                Task {
                    await viewModel.syncWithServer()
                }
            }
        case .empty:
            CardView(icon: "person", title: "Recently assigned new hires") {
                HStack(spacing: 24) {
                    Text("0")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(Color("primary"))
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("No new hires yet")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                    Text("Check back later!")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.black)
                }
            }
        }
    }
}
