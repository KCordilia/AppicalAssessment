//
//  ToDoCardView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 09/02/2025.
//

import SwiftUI

struct ToDoCardView: View {
    @StateObject private var viewModel = ToDoViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("checkmark")
                Text("To do's due soon")
            }
        }
    }
}

#Preview {
    ToDoCardView()
}
