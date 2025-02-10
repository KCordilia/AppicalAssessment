//
//  IntroductionCardView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 09/02/2025.
//

import SwiftUI

struct IntroductionCardView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Image("IntroductionCardImage")
                    .resizable()
                    .scaledToFit()
                Text("Your new hires journey to success!")
                    .font(.system(size: 16, weight: .semibold))
                Text("As a manager responsible for onboarding new hires, your role is pivotal in guiding them towards success. By providing clear and comprehensive training, you lay a solid foundation for their professional growth.")
                    .font(.system(size: 16, weight: .light))
            }
            .padding()
            .padding(.top, 30)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

#Preview {
    IntroductionCardView()
}
