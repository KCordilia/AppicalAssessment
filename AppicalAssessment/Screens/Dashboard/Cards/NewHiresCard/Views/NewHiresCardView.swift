//
//  NewHiresCardView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 10/02/2025.
//

import SwiftUI
import SwiftData

struct NewHiresCardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: NewHiresViewModel

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: NewHiresViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationLink(destination: NewHiresView(newHires: viewModel.newHires)) {
            CardView(icon: "person", title: "Recently assigned new hires") {
                HStack(spacing: 24) {
                    Text("\(viewModel.newHires.count)")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(Color("primary"))
                    OverlappingAvatarsView(avatarURLs: viewModel.newHires.map { $0.avatar })
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("New hires started this month")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                    Text("Send them a message to make them feel welcome")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    do {
        // Create a configuration for SwiftData
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true) // Prevents writing to disk for preview

        // Create a container using the configuration
        let container = try ModelContainer(for: NewHire.self, configurations: configuration)

        // Create a context from the container
        let modelContext = ModelContext(container)

        // Insert some mock data (optional)
        let mockNewHire = NewHire(id: "1", firstName: "John", lastName: "Appleseed", startDate: "01-01-2025", avatar: "")
        modelContext.insert(mockNewHire)

        // Return the preview
        return NewHiresCardView(modelContext: modelContext)
    } catch {
        fatalError("Failed to create ModelContainer: \(error)")
    }
}
