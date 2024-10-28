//
//  MainStorage.swift
//  Library
//
//  Created by Maxim on 28.10.2024.
//

import Foundation

protocol MainStorage: AnyObject {
    func fetchBooks() -> [BookModel]
    func deleteBook(withId id: String)
}
