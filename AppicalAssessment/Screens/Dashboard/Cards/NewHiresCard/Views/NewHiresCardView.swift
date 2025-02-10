//
//  NewHiresCardView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 10/02/2025.
//

import SwiftUI

struct NewHiresCardView: View {
    @StateObject private var viewModel = NewHiresViewModel()

    var body: some View {
        CardView(icon: "person", title: "Recently assigned new hires") {
            HStack(spacing: 24) {
                Text("\(viewModel.newHires.count)")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(Color("primary"))
                OverlappingAvatarsView(avatarURLs: viewModel.newHires.map { $0.avatar })
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
        .onAppear {
            Task {
                try await viewModel.fetchNewHires()
            }
        }
    }
}

#Preview {
    NewHiresCardView()
}
