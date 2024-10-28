//
//  InputFields.swift
//  Library
//
//  Created by Maxim on 27.10.2024.
//

import Foundation

enum InputFields {
    case name
    case author
    case date

    var description: String {
        switch self {
        case .name:
            return StringConstants.enterName
        case .author:
            return StringConstants.enterAuthor
        case .date:
            return StringConstants.enterDate
        }
    }
}
