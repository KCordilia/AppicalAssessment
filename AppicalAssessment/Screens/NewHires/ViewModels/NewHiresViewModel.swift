//
//  NewHiresViewModel.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 06/02/2025.
//

import Foundation

enum ViewState<T> {
    case loading
    case success(T)
    case error(String)
    case empty
}

@MainActor
class NewHiresViewModel: ObservableObject {
    @Published var newHires: [NewHire] = []
    @Published var viewState: ViewState<[NewHire]> = .loading
    @Published var isAscending: Bool = true

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchNewHires() async throws {
        viewState = .loading
        do {
            let fetchedHires = try await networkService.fetch(from: APIEndpoint.newHires.rawValue, as: [NewHire].self)

            if fetchedHires.isEmpty {
                viewState = .empty
            } else {
                newHires = fetchedHires
                sortNewHires()
                viewState = .success(fetchedHires)
            }
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    func sortNewHires() {
        newHires.sort { isAscending ? $0.startDate < $1.startDate : $0.startDate > $1.startDate}
    }

    func toggleSortOrder() {
        isAscending.toggle()
        sortNewHires()
        print("Sorting order is now: \(isAscending ? "Ascending" : "Descending")")
    }
}
