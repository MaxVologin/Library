//
//  EditBookVM.swift
//  Library
//
//  Created by Maxim on 25.10.2024.
//

import Foundation

protocol EditBookViewModel: InputFieldHandler {
    var coordinator: Coordinator? { get set }
    var booksStorage: CoreDataBooksStorage? { get set }
    var book: BookModel? { get set }
    var isNewBook: Observable<Bool> { get }
    var bookErrors: Observable<[InputFields: InputFieldError]> { get }

    func saveButtonTapped()
}

final class EditBookVM: EditBookViewModel {

    weak var coordinator: Coordinator?

    var booksStorage: CoreDataBooksStorage?

    var book: BookModel? {
        didSet {
            setNewBookIfNeeded()
        }
    }

    var isNewBook: Observable<Bool> = Observable(false)

    var bookErrors: Observable<[InputFields: InputFieldError]> = Observable([:])

    func saveButtonTapped() {
        if validateBook() {
            updateBooks()
            coordinator?.dismiss()
        }
    }

    private func updateBooks() {
        guard let book, let books = booksStorage?.fetchBooks() else {
            return
        }
        if books.contains(where: { $0.id == book.id }) {
            booksStorage?.updateBook(withId: book.id, updatedBook: book)
        } else {
            booksStorage?.saveBook(book: book)
        }
    }

    private func setNewBookIfNeeded() {
        if book == nil {
            isNewBook.value = true
            book = BookModel()
        }
    }

    private func validateBook() -> Bool {
        bookErrors.value = [:]

        guard let book else {
            return false
        }

        let isNameValid = !book.name.isEmpty
        let isAuthorValid = !book.author.isEmpty
        let isDateValid = !book.date.isEmpty

        if !isNameValid {
            bookErrors.value[.name] = .isEmpty
        }
        if !isAuthorValid {
            bookErrors.value[.author] = .isEmpty
        }
        if !isDateValid {
            bookErrors.value[.date] = .isEmpty
        }

        return isNameValid && isAuthorValid && isDateValid
    }
}

extension EditBookVM {
    func inputField(_ field: InputFields, didChange text: String?) {
        guard let text else {
            return
        }
        switch field {
        case .name:
            book?.name = text
        case .author:
            book?.author = text
        case .date:
            book?.date = text
        }
    }
}
