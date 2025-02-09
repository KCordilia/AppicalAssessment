//
//  ToDoItem.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 08/02/2025.
//

import Foundation

struct ToDoItem: Codable {
    let id: Int
    let title: String
    let dueDate: String
    var isCompleted: Bool
}
