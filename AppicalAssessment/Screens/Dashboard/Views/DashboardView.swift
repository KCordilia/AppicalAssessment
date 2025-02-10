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
                        .padding()
                    VStack(alignment: .leading) {
                        Text("To do's")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.horizontal)
                            .padding(.bottom, 16)
                        ToDoCardView()
                        Divider()
                            .padding()
                        Text("New hires")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.horizontal)
                            .padding(.bottom, 16)
                        NavigationLink(destination: NewHiresView()) {
                            NewHiresCardView()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
