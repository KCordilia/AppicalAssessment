//
//  ToDoItemView.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 09/02/2025.
//

import SwiftUI

struct ToDoItemView: View {
    let todo: ToDoItem
    let toggleCompletion: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Button(action: {
                toggleCompletion()
            }) {
                Image(todo.isCompleted ? "checklist.completed" : "checklist.open")
            }
            VStack(alignment: .leading) {
                Text(todo.title)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(todo.isCompleted ? .gray : .black)
                    .strikethrough(todo.isCompleted , color: .gray)
                    .animation(.easeInOut(duration: 0.15), value: todo.isCompleted)
                HStack {
                    let (dueDateText, dueDateColor) = formattedDueDateAndColor(todo.dueDate)
                    Image("calendar")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(dueDateColor)
                    Text(dueDateText)
                        .font(.system(size: 14, weight: .regular))
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
    ToDoItemView(todo: .init(id: "1", title: "Check the box", dueDate: "2025-02-12T07:08:10.132Z", isCompleted: true, isSynced: false), toggleCompletion: {})
}
