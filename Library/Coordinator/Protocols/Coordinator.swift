//
//  Coordinator.swift
//  Library
//
//  Created by Maxim on 28.10.2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }

    func start()
}
