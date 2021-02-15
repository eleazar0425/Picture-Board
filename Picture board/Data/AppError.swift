//
//  AppError.swift
//  Picture board
//
//  Created by Eleazar Estrella on 2/15/21.
//

import Foundation


struct AppError {
    let message: String

    init(message: String) {
        self.message = message
    }
}

extension AppError: LocalizedError {
    var errorDescription: String? { return message }
//    var failureReason: String? { get }
//    var recoverySuggestion: String? { get }
//    var helpAnchor: String? { get }
}
