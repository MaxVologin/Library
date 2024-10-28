//
//  EditBookVC.swift
//  Library
//
//  Created by Maxim on 25.10.2024.
//

import UIKit

final class EditBookVC: UIViewController, InputFieldDelegate {

    private enum Constants {
        static let stackInset: CGFloat = 16
        static let buttonBottomInset: CGFloat = 8
        static let saveButtonRadius: CGFloat = 20
        static let saveButtonHeight: CGFloat = 40
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = StringConstants.editBook

        addTapGesture()
        configureBindings()
        setViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextFiled.setText(viewModel.book?.name)
        authorTextFiled.setText(viewModel.book?.author)
        dateTextFiled.setText(viewModel.book?.date)
    }

    var viewModel: EditBookViewModel!

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextFiled, authorTextFiled, dateTextFiled])
        stackView.spacing = Constants.stackInset
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var nameTextFiled: InputField = makeInputField(.name) { [weak self] in
        self?.authorTextFiled.becomeFirstResponder()
    }

    private lazy var authorTextFiled: InputField = makeInputField(.author) { [weak self] in
        self?.dateTextFiled.becomeFirstResponder()
    }

    private lazy var dateTextFiled: InputField = makeInputField(.date) { [weak self] in
        self?.dateTextFiled.resignFirstResponder()
    }

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringConstants.save, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = Constants.saveButtonRadius
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func configureBindings() {
        viewModel.isNewBook.observe(on: self) { [weak self] in
            if $0 == true {
                self?.setNewBookTitle()
            }
        }
        viewModel.bookErrors.observe(on: self) { [weak self] in
            self?.setErrors($0)
        }
    }

    private func setNewBookTitle() {
        title = StringConstants.addBook
    }

    private func setErrors(_ errors: [InputFields : InputFieldError]) {
        nameTextFiled.setError(errors[.name])
        authorTextFiled.setError(errors[.author])
        dateTextFiled.setError(errors[.date])
    }

    private func setViews() {
        setContentView()
        setSaveButton()
    }

    private func setContentView() {
        view.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.stackInset),
            contentStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.stackInset),
            contentStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.stackInset)
        ])
    }

    private func setSaveButton() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.stackInset),
            saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.stackInset),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonBottomInset),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.saveButtonHeight)
        ])
    }

    private func makeInputField(_ fieldType: InputFields, completion: @escaping () -> Void) -> InputField {
        let inputField = InputField()
        inputField.delegate = self
        inputField.setPlaceholder(fieldType: fieldType)
        inputField.returnButtonTapped = completion
        return inputField
    }

    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }

    @objc
    private func saveButtonTapped() {
        viewModel.saveButtonTapped()
    }
}

extension EditBookVC {
    func inputField(_ field: InputField, didChange text: String?) {
        switch field {
        case nameTextFiled:
            viewModel.inputField(.name, didChange: text)
        case authorTextFiled:
            viewModel.inputField(.author, didChange: text)
        case dateTextFiled:
            viewModel.inputField(.date, didChange: text)
        default:
            break
        }
    }
}
