//
//  LibraryTableView.swift
//  Library
//
//  Created by Maxim on 22.10.2024.
//

import UIKit

protocol LibraryTableViewDelegate: AnyObject {
    func removeBook(byId: String)
    func selected(book: BookModel)
}

final class LibraryTableView: UITableView {

    private enum Constants {
        static let trashImage = UIImage(systemName: "trash")
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
        setupDiffableDataSource()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var libraryDelegate: LibraryTableViewDelegate?

    var diffableDataSource: UITableViewDiffableDataSource<LibrarySection, BookModel>?

    var books: [BookModel] = [] {
        didSet {
            updateDiffableDataSource()
        }
    }

    func updateDiffableDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<LibrarySection, BookModel>()
        snapshot.appendSections([.books])
        snapshot.appendItems(books, toSection: .books)

        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func configure() {
        backgroundColor = .lightGray
        delegate = self
        register(BookCell.self)
    }

    private func setupDiffableDataSource() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: self, cellProvider: { tableView, indexPath, book in
            let cell: BookCell = self.dequeueReusableCell(forIndexPath: indexPath)
            cell.book = book
            return cell
        })
    }
}

extension LibraryTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            let book = self?.books[indexPath.row]
            self?.libraryDelegate?.removeBook(byId: book?.id ?? "")
            completionHandler(true)
        }
        deleteAction.image = Constants.trashImage
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        libraryDelegate?.selected(book: books[indexPath.row])
    }
}
