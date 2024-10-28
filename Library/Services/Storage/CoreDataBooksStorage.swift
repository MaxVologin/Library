//
//  CoreDataBooksStorage.swift
//  Library
//
//  Created by Maxim on 27.10.2024.
//

import CoreData

final class CoreDataBooksStorage {

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    func saveBook(book: BookModel) {
        let context = coreDataStorage.persistentContainer.viewContext
        let newBook = BookEntity(context: context)
        newBook.id = book.id
        newBook.name = book.name
        newBook.author = book.author
        newBook.date = book.date

        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }

    func fetchBooks() -> [BookModel] {
        let context = coreDataStorage.persistentContainer.viewContext
        var books: [BookModel] = []

        let fetchRequest = NSFetchRequest<BookEntity>(entityName: "BookEntity")

        do {
            let results = try context.fetch(fetchRequest)
            books = results.map { BookModel(id: $0.id ?? "", name: $0.name ?? "", author: $0.author ?? "", date: $0.date ?? "") }
        } catch {
            print("Failed fetching")
        }

        return books
    }

    func deleteBook(withId id: String) {
        let context = coreDataStorage.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<BookEntity>(entityName: "BookEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            if let result = try context.fetch(fetchRequest).first {
                context.delete(result)
                try context.save()
            }
        } catch {
            print("Could not fetch or delete. \(error.localizedDescription)")
        }
    }

    func updateBook(withId id: String, updatedBook: BookModel) {
        let context = coreDataStorage.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<BookEntity>(entityName: "BookEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            if let result = try context.fetch(fetchRequest).first {
                result.setValue(updatedBook.name, forKey: "name")
                result.setValue(updatedBook.author, forKey: "author")
                result.setValue(updatedBook.date, forKey: "date")

                try context.save()
            }
        } catch {
            print("Could not fetch or update. \(error.localizedDescription)")
        }
    }

    private let coreDataStorage: CoreDataStorage
}
