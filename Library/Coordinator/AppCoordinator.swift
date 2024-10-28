//
//  AppCoordinator.swift
//  Library
//
//  Created by Maxim on 21.10.2024.
//

import UIKit

final class AppCoordinator: Coordinator, MainCoordinator, EditBookCoordinator {

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    var navigationController: UINavigationController

    func start() {
        let mainVM = MainVM()
        mainVM.coordinator = self
        mainVM.booksStorage = CoreDataBooksStorage()
        let mainVC = MainVC()
        mainVC.viewModel = mainVM
        navigationController.pushViewController(mainVC, animated: false)
    }

    func systemAlert(arguments: SystemAlertArguments) {
        let vc = UIAlertController(
            title: arguments.header,
            message: nil,
            preferredStyle: .actionSheet
        )
        for action in arguments.actions {
            let alertAction = UIAlertAction(
                title: action.title,
                style: action.style,
                handler: { _ in
                    action.handler?()
                }
            )
            vc.addAction(alertAction)
        }
        navigationController.present(vc, animated: true)
    }

    func openEditBook(with book: BookModel?) {
        let editBookVM = EditBookVM()
        let editBookVC = EditBookVC()
        editBookVC.viewModel = editBookVM
        editBookVM.coordinator = self
        editBookVM.book = book
        editBookVM.booksStorage = CoreDataBooksStorage()
        navigationController.pushViewController(editBookVC, animated: true)
    }

    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
