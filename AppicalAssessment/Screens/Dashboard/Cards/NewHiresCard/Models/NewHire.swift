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
}

// SwiftData model for local storage
@Model
class NewHire: Codable {
    @Attribute(.unique) var id: String
    var firstName: String
    var lastName: String
    var startDate: String
    var avatar: String
    var isSynced: Bool

    init(id: String, firstName: String, lastName: String, startDate: String, avatar: String, isSynced: Bool) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.startDate = startDate
        self.avatar = avatar
        self.isSynced = isSynced
    }

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, startDate, avatar, isSynced
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.startDate = try container.decode(String.self, forKey: .startDate)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        self.isSynced = try container.decode(Bool.self, forKey: .isSynced)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(isSynced, forKey: .isSynced)
    }


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

    var avatarURL: URL? {
        URL(string: avatar)
    }
}

