//
//  ToDoViewModel.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 09/02/2025.
//

import Foundation
import SwiftUI

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
                print(fetchedToDos)
            }
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

//    func toggleCompletion(for todo: ToDoItem) {
//        if let index = todos.firstIndex(where: {$0.id == todo.id}) {
//            todos[index].isCompleted.toggle()
//        }
//    }

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
