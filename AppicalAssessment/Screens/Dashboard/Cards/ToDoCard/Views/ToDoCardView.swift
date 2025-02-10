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
        CardView(icon: "checkmark", title: "To do's due soon") {
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
        .onAppear {
            Task {
                try await viewModel.fetchTodos()
            }
        }
    }
}

#Preview {
    ToDoCardView()
}
