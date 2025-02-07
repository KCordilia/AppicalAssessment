//
//  NewHireCellView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 06/02/2025.
//

import SwiftUI

struct NewHireCellView: View {
    let name: String
    let startDate: String
    let avatar: String

    var body: some View {
        HStack(spacing: 24) {
            AsyncImage(url: URL(string: avatar)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                case .failure:
                    Image(systemName: "person.slash")

                default:
                    Image(systemName: "person")
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.system(.title2, weight: .regular))

                HStack(spacing: 4) {
                    Text("First day")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(startDate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Button(action: {
                    // Action to send welcome message
                    print("Send welcome message to \(name)")
                }) {
                    Text("Send welcome message")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    NewHireCellView(name: "Tessa Mark", startDate: "08 feb 2025", avatar: "https://loremflickr.com/640/480/people")
}
