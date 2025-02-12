//
//  ErrorView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 12/02/2025.
//

import SwiftUI

struct ErrorView: View {
    var error: AppError
    var retryAction: (() -> Void)?

    var body: some View {
        CardView {
            VStack {
                Text("Oops! Something went wrong.")
                    .font(.headline)
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                    .padding()
                
                if let retryAction = retryAction {
                    Button(action: retryAction) {
                        Text("Try Again")
                            .foregroundColor(Color("primary"))
                            .font(.headline)
                    }
                    .padding(.top)
                }
            }
        }
    }
}

#Preview {
    ErrorView(error: .unknownError, retryAction: {})
}
