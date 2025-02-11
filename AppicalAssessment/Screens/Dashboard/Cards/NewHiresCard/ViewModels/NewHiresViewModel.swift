//
//  NewHiresViewModel.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 06/02/2025.
//

import Foundation
import SwiftData

@MainActor
class NewHiresViewModel: ObservableObject {
    @Published var newHires: [NewHire] = []
    @Published var viewState: ViewState<[NewHire]> = .loading
    @Published var sortingOption: SortingOption = .earliestDateFirst

    private let networkService: NetworkServiceProtocol
    private var modelContext: ModelContext

    init(networkService: NetworkServiceProtocol = NetworkService(), modelContext: ModelContext) {
        self.networkService = networkService
        self.modelContext = modelContext
        self.newHires = fetchLocalNewHires()

        Task {
            do {
                try await fetchNewHires()
            } catch {
                print("Failed to fetch new hires")
            }
        }
    }

    func fetchNewHires() async throws {
        viewState = .loading
        do {
            let fetchedHires = try await networkService.fetch(from: APIEndpoint.newHires.rawValue, as: [NewHireResponse].self)

            if fetchedHires.isEmpty {
                viewState = .empty
            } else {
                for newHireResponse in fetchedHires {
                    let newHire = NewHire(id: newHireResponse.id, firstName: newHireResponse.firstName, lastName: newHireResponse.lastName, startDate: newHireResponse.startDate, avatar: newHireResponse.avatar)
                    modelContext.insert(newHire)
                }
                try modelContext.save()
                newHires = fetchedHires.map { NewHire(id: $0.id, firstName: $0.firstName, lastName: $0.lastName, startDate: $0.startDate, avatar: $0.avatar) }
                sortNewHires()
                viewState = .success(newHires)
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

    private func fetchLocalNewHires() -> [NewHire] {
        let descriptor = FetchDescriptor<NewHire>(sortBy: [SortDescriptor(\.id)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}
