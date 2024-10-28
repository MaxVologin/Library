//
//  SortingState.swift
//  Library
//
//  Created by Maxim on 24.10.2024.
//

import Foundation

enum SortingState: String {
    case name
    case author
    case date

    var description: String {
        switch self {
        case .name:
            return StringConstants.byName
        case .author:
            return StringConstants.byAuthor
        case .date:
            return StringConstants.byDate
        }
    }
}
