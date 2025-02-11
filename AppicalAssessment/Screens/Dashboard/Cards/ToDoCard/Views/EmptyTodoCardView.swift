//
//  EmptyTodoCardView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 11/02/2025.
//

import SwiftUI

struct EmptyTodoCardView: View {
    var body: some View {
        CardView {
            VStack(spacing: 4) {
                Image("celebrate")
                    .padding()
                    .frame(maxWidth: .infinity)
                Text("Nice work!")
                Text("You've completed all your to do's")
            }
        }
    }
}

#Preview {
    EmptyTodoCardView()
}
