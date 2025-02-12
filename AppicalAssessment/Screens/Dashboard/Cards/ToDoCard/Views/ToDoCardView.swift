//
//  ToDoCardView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 09/02/2025.
//

import SwiftUI
import SwiftData

struct ToDoCardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ToDoViewModel

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: ToDoViewModel(modelContext: modelContext))
    }

    var body: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .success(let todos):
            CardView(icon: "checkmark", title: "To do's due soon") {
                VStack(alignment: .leading) {
                    ForEach(todos, id: \.id) { todo in
                        ToDoItemView(todo: todo) {
                            Task {
                                viewModel.toggleCompletion(for: todo)
                            }
                        }
                    }
                }
            }
        case .error(let error):
            ErrorView(error: error) {
                Task {
                    await viewModel.syncWithServer()
                }
            }
        case .empty:
            EmptyTodoCardView()
        }
    }
}
