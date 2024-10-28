//
//  InputField.swift
//  Library
//
//  Created by Maxim on 25.10.2024.
//

import UIKit

protocol InputFieldDelegate: AnyObject {
    func inputField(_ field: InputField, didChange text: String?)
}

final class InputField: UIView {

    private enum Constants {
        static let stackSpacing: CGFloat = 5
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        static let errorLabelHeight: CGFloat = 20
        static let verticalInset: CGFloat = 8
        static let horizontalInset: CGFloat = 16
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: InputFieldDelegate?

    var returnButtonTapped: (() -> Void)?

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }

    func setText(_ text: String?) {
        textField.text = text
    }

    func setPlaceholder(fieldType: InputFields) {
        textField.placeholder = fieldType.description
    }

    func setError(_ error: InputFieldError?) {
        if let error {
            errorLabel.isHidden = false
            errorLabel.text = error.description
            fieldView.layer.borderWidth = Constants.borderWidth
        } else {
            errorLabel.isHidden = true
            fieldView.layer.borderWidth = .zero
        }
    }

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fieldView, errorLabel])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        return stack
    }()

    private lazy var fieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.borderColor = UIColor.red.cgColor
        return view
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        return textField
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .red
        return label
    }()

    private func configure() {
        setContentStackView()
        setTextField()
    }

    private func setContentStackView() {
        addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leftAnchor.constraint(equalTo: leftAnchor),
            contentStackView.rightAnchor.constraint(equalTo: rightAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            errorLabel.heightAnchor.constraint(equalToConstant: Constants.errorLabelHeight)
        ])
    }

    private func setTextField() {
        fieldView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: fieldView.topAnchor, constant: Constants.verticalInset),
            textField.leftAnchor.constraint(equalTo: fieldView.leftAnchor, constant: Constants.horizontalInset),
            textField.rightAnchor.constraint(equalTo: fieldView.rightAnchor, constant: -Constants.horizontalInset),
            textField.bottomAnchor.constraint(equalTo: fieldView.bottomAnchor, constant: -Constants.verticalInset),
        ])
    }
}

extension InputField: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.inputField(self, didChange: textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnButtonTapped?()
        return true
    }
}
