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
    @Published var sortingOption: SortingOption = .earliestDateFirst

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
        switch sortingOption {
        case .earliestDateFirst:
            newHires.sort { $0.startDate < $1.startDate }
        case .latestDateFirst:
            newHires.sort { $0.startDate > $1.startDate }
        }

    }

    func toggleSortOrder() {
        sortNewHires()
    }
}
