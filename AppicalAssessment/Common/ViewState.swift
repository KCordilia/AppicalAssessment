//
//  ViewState.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 09/02/2025.
//

import Foundation

enum ViewState<T> {
    case loading
    case success(T)
    case error(AppError)
    case empty
}
