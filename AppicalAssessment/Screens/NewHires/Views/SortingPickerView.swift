//
//  SortingPickerView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 07/02/2025.
//

import SwiftUI

enum SortingOption: String, CaseIterable {
    case earliestDateFirst = "Earliest Start Date First"
    case latestDateFirst = "Latest Start Date First"
}

struct SortingPickerView: View {
    @Binding var selectedOption: SortingOption

    var body: some View {
        Menu {
            Picker("Sort by", selection: $selectedOption) {
                ForEach(SortingOption.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .tag(option)
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    SortingPickerView(selectedOption: .constant(.earliestDateFirst))
}
