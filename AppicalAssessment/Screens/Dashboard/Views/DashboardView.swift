//
//  DashboardView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 07/02/2025.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = DashboardViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center) {
                    Image("AppicalLogo")
                    Text("Welcome back, \(viewModel.user.firstName)!")
                        .font(.system(size: 24, weight: .semibold))
                    IntroductionCardView()
                    Divider()
                        .padding(.vertical)
                    VStack(alignment: .leading) {
                        Text("To do's")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.horizontal)
                        IntroductionCardView()

                    }
                    NavigationLink(destination: NewHiresView()) {
                        Text("Go to new hires")
                    }
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
