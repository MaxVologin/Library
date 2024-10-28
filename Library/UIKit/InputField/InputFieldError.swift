//
//  InputFieldError.swift
//  Library
//
//  Created by Maxim on 26.10.2024.
//

import Foundation

enum InputFieldError {
    case isEmpty

    var description: String {
        switch self {
        case .isEmpty:
            return StringConstants.emptyFieldError
        }
    }
}
