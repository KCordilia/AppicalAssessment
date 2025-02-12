//
//  NewHiresView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 06/02/2025.
//

import SwiftUI

struct NewHiresView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var sortingOption: SortingOption = .earliestDateFirst
    let newHires: [NewHire]

    var sortedNewHires: [NewHire] {
        switch sortingOption {
        case .earliestDateFirst:
            return newHires.sorted { $0.startDate < $1.startDate }
        case .latestDateFirst:
            return newHires.sorted { $0.startDate > $1.startDate }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Welcome your new hires")
                    .padding(.horizontal)
                    .padding(.vertical, 0)
                    .font(.system(size: 20, weight: .semibold))
                    .bold()
                List {
                    ForEach(sortedNewHires, id: \.id) { newHire in
                        NewHireCellView(
                            name: newHire.fullName,
                            startDate: newHire.formattedStartDate,
                            avatar: newHire.avatar
                        )
                        .buttonStyle(.plain)
                    }

                }
                .contentMargins(.vertical, 0)
                .padding(.top, 0)
                .listStyle(.insetGrouped)
            }
            .background(Color(.systemGroupedBackground))
        }
        .padding(0)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .bold))
                }
                .tint(.white)
            }
            ToolbarItem(placement: .principal) {
                Text("Recently assigned new hires")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .bold))
            }
            ToolbarItem(placement: .topBarTrailing) {
                SortingPickerView(selectedOption: $sortingOption)
            }
        }
        .toolbarBackground(Color("primary"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
#Preview {
    NewHiresView(newHires: [.init(id: "1", firstName: "john", lastName: "appleseed", startDate: "01-01-2025", avatar: "", isSynced: false),
                            .init(id: "1", firstName: "john", lastName: "appleseed", startDate: "01-01-2025", avatar: "", isSynced: false),
                            .init(id: "1", firstName: "john", lastName: "appleseed", startDate: "01-01-2025", avatar: "", isSynced: false),
                            .init(id: "1", firstName: "john", lastName: "appleseed", startDate: "01-01-2025", avatar: "", isSynced: false)])
}
