//
//  MainVC.swift
//  Library
//
//  Created by Maxim on 21.10.2024.
//

import UIKit

final class MainVC: UIViewController {

    private enum Constants {
        static let sortingViewHeight: CGFloat = 44
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureBindings()

        setNavigationBar()
        setSearchBar()
        setSortingView()
        setTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateSearchBar(text: searchController.searchBar.text ?? "")
    }

    var viewModel: MainViewModel!

    private var searchController = UISearchController(searchResultsController: nil)

    private var libraryTableView = LibraryTableView()

    private var sortingView = SortingView()

    private func configureBindings() {
        viewModel.books.observe(on: self) { [weak self] in self?.libraryTableView.books = $0 }
        viewModel.sortingState.observe(on: self) { [weak self] in self?.sortingView.sortingState = $0 }
    }

    private func setNavigationBar() {
        title = StringConstants.library
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addBookDidTap)
        )
    }

    private func setSearchBar() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = StringConstants.search
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
    }

    private func setSortingView() {
        sortingView.delegate = viewModel
        view.addSubview(sortingView)
        sortingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            sortingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            sortingView.heightAnchor.constraint(equalToConstant: Constants.sortingViewHeight)
        ])
    }

    private func setTableView() {
        libraryTableView.libraryDelegate = viewModel
        view.addSubview(libraryTableView)
        libraryTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            libraryTableView.topAnchor.constraint(equalTo: sortingView.bottomAnchor),
            libraryTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            libraryTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            libraryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc
    private func addBookDidTap() {
        viewModel.addBook()
    }
}

extension MainVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchBar(text: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}
