//
//  SystemAlertArguments.swift
//  Library
//
//  Created by Maxim on 24.10.2024.
//

import UIKit

struct SystemAlertArguments {
    struct Action {
        var title: String?
        var style: UIAlertAction.Style = .default
        var handler: (() -> Void)?
    }

    var header: String?
    var actions: [Action] = []
}
