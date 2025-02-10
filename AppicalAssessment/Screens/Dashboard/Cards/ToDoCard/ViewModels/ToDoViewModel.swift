//
//  ToDoViewModel.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 09/02/2025.
//

import Foundation
import SwiftUI

@MainActor
class ToDoViewModel: ObservableObject {
    @Published var todos: [ToDoItem] = []
    @Published var viewState: ViewState<[ToDoItem]> = .loading

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchTodos() async throws {
        viewState = .loading
        do {
            let fetchedToDos = try await networkService.fetch(from: APIEndpoint.todos.rawValue, as: [ToDoItem].self)

            if fetchedToDos.isEmpty {
                viewState = .empty
            } else {
                todos = fetchedToDos
                viewState = .success(fetchedToDos)
            }
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    func toggleCompletion(for todo: ToDoItem) async {
        if let index = todos.firstIndex(where: {$0.id == todo.id}) {
            var updatedTodo = todos[index]
            updatedTodo.isCompleted.toggle()
            todos[index] = updatedTodo
            do {
                try await networkService.update(to: APIEndpoint.todos.rawValue, id: updatedTodo.id,  body: updatedTodo)
            } catch {
                print("Error updating todo: \(error.localizedDescription)")
            }
        }
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
}
