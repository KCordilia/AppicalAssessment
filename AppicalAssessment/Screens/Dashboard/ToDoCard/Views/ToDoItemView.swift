//
//  ToDoItemView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 09/02/2025.
//

import SwiftUI

struct ToDoItemView: View {
    let todo: ToDoItem

    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .stroke(todo.isCompleted ? Color.blue : Color.gray, lineWidth:  2)
                .frame(width: 24, height: 24)
                .overlay(todo.isCompleted ? Image(systemName: "checkmark") : nil)
            VStack(alignment: .leading) {
                Text(todo.title)
                HStack {
                    let (dueDateText, dueDateColor) = formattedDueDateAndColor(todo.dueDate)
                    Image("calendar")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(dueDateColor)
                    Text(dueDateText)
                        .foregroundColor(dueDateColor)
                }
            }
        }
    }

    private func formattedDueDateAndColor(_ dueDateString: String) -> (text: String, color: Color) {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let dueDate = isoFormatter.date(from: dueDateString) else {
            return ("Due Unknown", .gray)
        }

        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"

        if calendar.isDateInToday(dueDate) {
            return ("Today", .red)
        } else if calendar.isDateInTomorrow(dueDate) {
            return ("Tomorrow", .green)
        } else {
            return ("Due \(formatter.string(from: dueDate))", .gray)
        }
    }
}

#Preview {
    ToDoItemView(todo: .init(id: 1, title: "Check the box", dueDate: "2025-02-12T07:08:10.132Z", isCompleted: true))
}
