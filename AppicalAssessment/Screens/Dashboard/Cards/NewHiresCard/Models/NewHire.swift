//
//  NewHire.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 06/02/2025.
//

import Foundation
import SwiftData

// Codable model for API Response
struct NewHireResponse: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let startDate: String
    let avatar: String

    // Computed property to format the date
    var formattedStartDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // API date format
        if let date = dateFormatter.date(from: startDate) {
            dateFormatter.dateFormat = "dd MMM yyyy" // Desired format
            return dateFormatter.string(from: date)
        }
        return "Invalid Date"
    }

    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

// SwiftData model for local storage
@Model
class NewHire {
    @Attribute(.unique) var id: String
    var firstName: String
    var lastName: String
    var startDate: String
    var avatar: String

    init(id: String, firstName: String, lastName: String, startDate: String, avatar: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.startDate = startDate
        self.avatar = avatar
    }


}

