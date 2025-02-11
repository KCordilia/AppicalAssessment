//
//  ToDoItem.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 08/02/2025.
//

import Foundation
import SwiftData

struct ToDoItemResponse: Codable {
    let id: String
    let title: String
    let dueDate: String
    var isCompleted: Bool
}

@Model
class ToDoItem: Codable {
    @Attribute(.unique) var id: String
    var title: String
    var dueDate: String
    var isCompleted: Bool
    var isSynced: Bool

    init(id: String, title: String, dueDate: String, isCompleted: Bool, isSynced: Bool) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.isSynced = isSynced
    }

    enum CodingKeys: String, CodingKey {
        case id, title, dueDate, isCompleted, isSynced
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.dueDate = try container.decode(String.self, forKey: .dueDate)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        self.isSynced = try container.decode(Bool.self, forKey: .isSynced)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(isSynced, forKey: .isSynced)
    }
}
