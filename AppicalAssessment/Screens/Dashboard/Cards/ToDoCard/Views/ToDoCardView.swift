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
        case .error:
            Rectangle()
        case .empty:
            EmptyTodoCardView()
        }
    }
}

#Preview {
//    do {
//        // Create a configuration for SwiftData
//        let configuration = ModelConfiguration(isStoredInMemoryOnly: true) // Prevents writing to disk for preview
//
//        // Create a container using the configuration
//        let container = try ModelContainer(for: ToDoItem.self, configurations: configuration)
//
//        // Create a context from the container
//        let modelContext = ModelContext(container)
//
//        // Insert some mock data (optional)
//        let mockToDo = ToDoItem(id: UUID().uuidString, title: "Sample Task", dueDate: "2025-02-10", isCompleted: false)
//        modelContext.insert(mockToDo)
//
//        // Return the preview
//        ToDoCardView(modelContext: modelContext)
//    } catch {
//        fatalError("Failed to create ModelContainer: \(error)")
//    }
}
