//
//  MainVM.swift
//  Library
//
//  Created by Maxim on 21.10.2024.
//

import Foundation

protocol MainViewModel: SortingDelegate, LibraryTableViewDelegate {
    var coordinator: Coordinator? { get set }
    var booksStorage: CoreDataBooksStorage? { get set }
    var books: Observable<[BookModel]> { get }
    var sortingState: Observable<SortingState> { get }

    func addBook()
    func editBook(with: BookModel)
    func updateSearchBar(text: String)
    func didCancelSearch()
}

final class MainVM: MainViewModel {

    weak var coordinator: Coordinator?
    
    var booksStorage: CoreDataBooksStorage?

    var books: Observable<[BookModel]> = Observable([])

    var sortingState: Observable<SortingState> = Observable(.name)

    func addBook() {
        coordinator?.openEditBook(with: nil)
    }

    func editBook(with book: BookModel) {
        coordinator?.openEditBook(with: book)
    }

    func updateSearchBar(text: String) {
        let sortedBooks = searchBooks(by: text)
        sortBooks(books: sortedBooks)
    }

    func didCancelSearch() {
        sortBooks(books: booksStorage?.fetchBooks())
    }

    private func searchBooks(by searchText: String) -> [BookModel] {
        guard let books = booksStorage?.fetchBooks() else {
            return []
        }
        if searchText.isEmpty {
            return books
        }
        let lowercasedSearchText = searchText.lowercased()
        let filteredBooks = books.filter { book in
            book.name.lowercased().contains(lowercasedSearchText) ||
            book.author.lowercased().contains(lowercasedSearchText) ||
            book.date.lowercased().contains(lowercasedSearchText)
        }
        return filteredBooks
    }

    private func sortBooks(books: [BookModel]?) {
        guard let books else {
            self.books.value = []
            return
        }
        switch sortingState.value {
        case .name:
            self.books.value = books.sorted { $0.name < $1.name }
        case .author:
            self.books.value = books.sorted { $0.author < $1.author }
        case .date:
            self.books.value = books.sorted { $0.date < $1.date }
        }
    }
}

extension MainVM {
    func sortingDidTap() {
        coordinator?.systemAlert(
            arguments: SystemAlertArguments(
                header: StringConstants.sorting,
                actions: [
                    .init(title: SortingState.name.description, handler: { [weak self] in
                        self?.changeSort(.name)
                    }),
                    .init(title: SortingState.author.description,handler: { [weak self] in
                        self?.changeSort(.author)
                    }),
                    .init(title: SortingState.date.description, handler: { [weak self] in
                        self?.changeSort(.date)
                    }),
                    .init(title: StringConstants.cancel, style: .cancel)
                ]
            )
        )
    }

    private func changeSort(_ state: SortingState) {
        sortingState.value = state
        sortBooks(books: books.value)
    }
}

extension MainVM {
    func removeBook(byId id: String) {
        booksStorage?.deleteBook(withId: id)
        sortBooks(books: booksStorage?.fetchBooks())
    }

    func selected(book: BookModel) {
        coordinator?.openEditBook(with: book)
    }
}
