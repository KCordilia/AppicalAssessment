//
//  AppicalAssessmentApp.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 06/02/2025.
//

import SwiftUI
import SwiftData

@main
struct AppicalAssessmentApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .modelContainer(for: [ToDoItem.self, NewHire.self])
        }
    }
}
