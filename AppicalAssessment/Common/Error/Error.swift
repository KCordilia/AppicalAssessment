//
//  Error.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 12/02/2025.
//

import Foundation

enum AppError: Error {
    case networkError
    case serverError
    case badURL
    case requestFailed(statusCode: Int)
    case decodingError
    case unknownError

    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Network error. Please check your internet connection."
        case .serverError:
            return "Our servers are having issues. Please try again later."
        case .badURL:
            return "Invalid request. Please try again."
        case .requestFailed(let statusCode):
            if (400...499).contains(statusCode) {
                return "Something went wrong. Please check your request."
            } else if (500...599).contains(statusCode) {
                return "Our servers are having issues. Please try again later."
            } else {
                return "Unexpected error occurred."
            }
        case .decodingError:
            return "Failed to process data. Please try again."
        case .unknownError:
            return "Something went wrong. Please try again."
        }
    }
}
