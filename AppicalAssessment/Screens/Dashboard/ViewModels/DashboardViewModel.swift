//
//  DashboardViewModel.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 06/02/2025.
//

import Foundation

class DashboardViewModel: ObservableObject {

    // hard coded user since logging in is not available yet
    @Published var user: User = User(id: 1, firstName: "John", lastName: "Stone", avatar: "https://loremflickr.com/640/480/people")
}
