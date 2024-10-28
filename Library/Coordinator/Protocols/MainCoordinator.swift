//
//  MainCoordinator.swift
//  Library
//
//  Created by Maxim on 28.10.2024.
//

import Foundation

protocol MainCoordinator: AnyObject {
    func systemAlert(arguments: SystemAlertArguments)
    func openEditBook(with book: BookModel?)
}
