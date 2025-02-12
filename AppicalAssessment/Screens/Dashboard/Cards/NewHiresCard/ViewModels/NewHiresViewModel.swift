//
//  NewHiresViewModel.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 06/02/2025.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class NewHiresViewModel: ObservableObject {
    @Published var newHires: [NewHire] = []
    @Published var viewState: ViewState<[NewHire]> = .loading
    @Published var sortingOption: SortingOption = .earliestDateFirst
    @Published var avatars: [String: Image] = [:]

    private let networkService: NetworkServiceProtocol
    private var modelContext: ModelContext

    init(networkService: NetworkServiceProtocol = NetworkService(), modelContext: ModelContext) {
        self.networkService = networkService
        self.modelContext = modelContext
        self.newHires = fetchLocalNewHires()

        Task {
            await syncWithServer()
        }
    }

    // Loads from local storage first, then fetches and merges remote newHires
        func syncWithServer() async {
            viewState = .loading

            // Fetch fresh data from the backend
            do {
                let fetchedNewHires = try await networkService.fetch(from: APIEndpoint.newHires.rawValue, as: [NewHireResponse].self)

                // Merge with local newHires
                mergeFetchedNewHires(fetchedNewHires)

                // Refresh UI
                newHires = fetchLocalNewHires()
                if newHires.isEmpty {
                    viewState = .empty
                } else {
                    viewState = .success(newHires)
                }
            } catch is URLError {
                viewState = .error(.networkError)
            } catch is DecodingError {
                viewState = .error(.decodingError)
            } catch {
                viewState = .error(.unknownError)
            }
        }

    // Merges fetched newHire with local data, avoiding unnecessary overwrites
    private func mergeFetchedNewHires(_ fetchedNewHires: [NewHireResponse]) {
        let localNewHires = fetchLocalNewHires()
        let localNewHiresDict = Dictionary(uniqueKeysWithValues: localNewHires.map { ($0.id, $0) })

        for newHireResponse in fetchedNewHires {
            if let localNewHire = localNewHiresDict[newHireResponse.id] {
                // Only update if there's a difference
                if localNewHire.id != newHireResponse.id {
                    localNewHire.firstName = newHireResponse.firstName
                    localNewHire.lastName = newHireResponse.lastName
                    localNewHire.startDate = newHireResponse.startDate
                    localNewHire.avatar = newHireResponse.avatar
                    localNewHire.isSynced = true
                }
            } else {
                // New newHire from the server
                let newHire = NewHire(
                    id: newHireResponse.id,
                    firstName: newHireResponse.firstName,
                    lastName: newHireResponse.lastName,
                    startDate: newHireResponse.startDate,
                    avatar: newHireResponse.avatar,
                    isSynced: true
                )
                modelContext.insert(newHire)
            }
        }


        // Remove newHires that no longer exist on the server
        let fetchedIDs = Set(fetchedNewHires.map { $0.id })
        for localNewHire in localNewHires where !fetchedIDs.contains(localNewHire.id) {
            modelContext.delete(localNewHire)
        }

        try? modelContext.save()
    }

    func syncPendingChanges() async {
        let unsyncedNewHires = fetchLocalNewHires().filter { !$0.isSynced }

        for newHire in unsyncedNewHires {
            do {
                try await networkService.update(to: APIEndpoint.newHires.rawValue, id: newHire.id, body: newHire)
                newHire.isSynced = true
            } catch {
                print("Failed to sync newHire \(newHire.id): \(error.localizedDescription)")
            }
        }

        try? modelContext.save()
    }

    private func fetchLocalNewHires() -> [NewHire] {
        let descriptor = FetchDescriptor<NewHire>(sortBy: [SortDescriptor(\.id)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}
