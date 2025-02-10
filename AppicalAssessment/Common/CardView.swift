//
//  CardView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 10/02/2025.
//

import SwiftUI

struct CardView<Content: View>: View {
    let icon: String?
    let title: String?
    let content: Content

    init(icon: String? = nil, title: String? = nil, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                if let icon = icon, let title = title {
                    HStack {
                        Image(icon)
                        Text(title)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 16)
                }
                content
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CardView(icon: "checkmark", title: "To do's due soon") {
        Text("hello")
    }
}
