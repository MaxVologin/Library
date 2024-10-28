//
//  EditBookStorage.swift
//  Library
//
//  Created by Maxim on 28.10.2024.
//

import Foundation

protocol EditBookStorage: AnyObject {
    func fetchBooks() -> [BookModel]
    func updateBook(withId id: String, updatedBook: BookModel)
    func saveBook(book: BookModel)
}
