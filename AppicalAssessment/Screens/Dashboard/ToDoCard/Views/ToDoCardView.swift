//
//  ToDoCardView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 09/02/2025.
//

import SwiftUI

struct ToDoCardView: View {
    @StateObject private var viewModel = ToDoViewModel()

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image("checkmark")
                    Text("To do's due soon")
                        .font(.system(size: 16, weight: .medium))
                }
                .padding(.bottom, 16)
                VStack(alignment: .leading) {
                    ForEach(viewModel.todos, id: \.id) { todo in
                        ToDoItemView(todo: todo) {
                            Task {
                                await viewModel.toggleCompletion(for: todo)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .onAppear {
                Task {
                    try await viewModel.fetchTodos()
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ToDoCardView()
}
