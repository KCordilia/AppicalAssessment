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
                updateViewState()
            } catch is URLError {
                viewState = .error(.networkError)
            } catch is DecodingError {
                viewState = .error(.decodingError)
            } catch {
                viewState = .error(.unknownError)
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
