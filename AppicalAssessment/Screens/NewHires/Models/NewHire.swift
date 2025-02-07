//
//  NewHire.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 06/02/2025.
//

import Foundation

struct NewHire: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let role: String
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
