//
//  OverlappingAvatarsView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 10/02/2025.
//

import SwiftUI

struct OverlappingAvatarsView: View {
    let avatarURLs: [String]
    let maxAvatarsToShow = 4
    private let offset: CGFloat = 30
    private let dimension: CGFloat = 50

    var body: some View {
        ZStack {
            ForEach(0..<min(avatarURLs.count, maxAvatarsToShow), id: \.self) { index in
                AsyncImage(url: URL(string: avatarURLs[index])) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: dimension, height: dimension)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .offset(x: CGFloat(index) * offset)
                } placeholder: {
                    ZStack {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: dimension, height: dimension)
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                }
            }
            if avatarURLs.count > maxAvatarsToShow {
                Text("+\(avatarURLs.count - maxAvatarsToShow)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 50, height: 50)
                    .background(Color.gray)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 2)
                    .offset(x: CGFloat(CGFloat(min(avatarURLs.count, maxAvatarsToShow)) * offset)) // Place it at the end
            }
        }
    }
}

#Preview {
    OverlappingAvatarsView(avatarURLs: ["https://loremflickr.com/640/480/people", "https://loremflickr.com/640/480/people", "https://loremflickr.com/640/480/people", "https://loremflickr.com/640/480/people", "https://loremflickr.com/640/480/people"])
}
