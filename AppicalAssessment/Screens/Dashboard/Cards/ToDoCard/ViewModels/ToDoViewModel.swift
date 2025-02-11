//
//  ToDoViewModel.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 09/02/2025.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class ToDoViewModel: ObservableObject {
    @Published var todos: [ToDoItem] = []
    @Published var viewState: ViewState<[ToDoItem]> = .loading

    private let networkService: NetworkServiceProtocol
    private var modelContext: ModelContext

    init(networkService: NetworkServiceProtocol = NetworkService(), modelContext: ModelContext) {
        self.networkService = networkService
        self.modelContext = modelContext
        self.todos = fetchLocalTodos()

        Task {
            await syncWithServer()
        }
    }

    // Loads from local storage first, then fetches and merges remote todos
        func syncWithServer() async {
            viewState = .loading

            // Fetch fresh data from the backend
            do {
                let fetchedTodos = try await networkService.fetch(from: APIEndpoint.todos.rawValue, as: [ToDoItemResponse].self)

                // Merge with local todos
                mergeFetchedTodos(fetchedTodos)

                // Refresh UI
                todos = fetchLocalTodos()
//                viewState = todos.isEmpty ? .empty : .success(todos)
                updateViewState()
            } catch {
                viewState = .error(error.localizedDescription)
            }
        }

    // Merges fetched todos with local data, avoiding unnecessary overwrites
    private func mergeFetchedTodos(_ fetchedTodos: [ToDoItemResponse]) {
        let localTodos = fetchLocalTodos()
        let localTodoDict = Dictionary(uniqueKeysWithValues: localTodos.map { ($0.id, $0) })

        for todoResponse in fetchedTodos {
            if let localTodo = localTodoDict[todoResponse.id] {
                // Only update if there's a difference
                if localTodo.title != todoResponse.title ||
                    localTodo.isCompleted != todoResponse.isCompleted ||
                    localTodo.dueDate != todoResponse.dueDate {
                    localTodo.title = todoResponse.title
                    localTodo.isCompleted = todoResponse.isCompleted
                    localTodo.dueDate = todoResponse.dueDate
                    localTodo.isSynced = true
                }
            } else {
                // New todo from the server
                let newTodo = ToDoItem(
                    id: todoResponse.id,
                    title: todoResponse.title,
                    dueDate: todoResponse.dueDate,
                    isCompleted: todoResponse.isCompleted,
                    isSynced: true
                )
                modelContext.insert(newTodo)
            }
        }

        // Remove todos that no longer exist on the server
        let fetchedIDs = Set(fetchedTodos.map { $0.id })
        for localTodo in localTodos where !fetchedIDs.contains(localTodo.id) {
            modelContext.delete(localTodo)
        }

        try? modelContext.save()
    }
//    // fetches to do's from the api and stores them in SwiftData
//    func fetchTodos() async throws {
//        viewState = .loading
//        do {
//            let fetchedTodos = try await networkService.fetch(from: APIEndpoint.todos.rawValue, as: [ToDoItemResponse].self)
//
//            if fetchedTodos.isEmpty {
//                viewState = .empty
//                return
//            }
//
//            // Fetch current local todos
//            var localTodos = fetchLocalTodos()
//
//            // Merge fetched todos with local storage
//            for todoResponse in fetchedTodos {
//                if let index = localTodos.firstIndex(where: { $0.id == todoResponse.id }) {
//                    // Update existing local todo
//                    localTodos[index].title = todoResponse.title
//                    localTodos[index].isCompleted = todoResponse.isCompleted
//                    localTodos[index].dueDate = todoResponse.dueDate
//                } else {
//                    // Add new todos from server
//                    let newTodo = ToDoItem(
//                        id: todoResponse.id,
//                        title: todoResponse.title,
//                        dueDate: todoResponse.dueDate,
//                        isCompleted: todoResponse.isCompleted
//                    )
//                    modelContext.insert(newTodo)
//                }
//            }
//
//            // Remove local todos that no longer exist on the server
//            let fetchedIDs = Set(fetchedTodos.map { $0.id })
//            for localTodo in localTodos {
//                if !fetchedIDs.contains(localTodo.id) {
//                    modelContext.delete(localTodo)
//                }
//            }
//
//            // Save the final updated state
//            try modelContext.save()
//
//            // Refresh the UI
//            todos = fetchLocalTodos()
//            viewState = .success(todos)
//        } catch {
//            viewState = .error(error.localizedDescription)
//        }
//    }

    func toggleCompletion(for todo: ToDoItem) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }

        todos[index].isCompleted.toggle()
        todos[index].isSynced = false // Mark as needing sync

        try? modelContext.save()

        Task {
            await syncPendingChanges()
        }

        updateViewState()
    }

    func syncPendingChanges() async {
        let unsyncedTodos = fetchLocalTodos().filter { !$0.isSynced }

        for todo in unsyncedTodos {
            do {
                try await networkService.update(to: APIEndpoint.todos.rawValue, id: todo.id, body: todo)
                todo.isSynced = true
            } catch {
                print("Failed to sync todo \(todo.id): \(error.localizedDescription)")
            }
        }

        try? modelContext.save()
    }

    func dueDateColor(for date: Date) -> Color {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return .red
        } else if calendar.isDateInTomorrow(date) {
            return .green
        } else {
            return .gray
        }
    }

    private func fetchLocalTodos() -> [ToDoItem] {
        let descriptor = FetchDescriptor<ToDoItem>(sortBy: [SortDescriptor(\.id)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    private func updateViewState() {
        if todos.allSatisfy({ $0.isCompleted }) {
            viewState = .empty
        } else {
            viewState = .success(todos)
        }
    }
}
