//
//  SortingView.swift
//  Library
//
//  Created by Maxim on 24.10.2024.
//

import UIKit

protocol SortingDelegate: AnyObject {
    func sortingDidTap()
}

final class SortingView: UIView {

    private enum Constants {
        static let sideInset: CGFloat = 16
        static let trashImage: String = "arrow.down"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: SortingDelegate?

    var sortingState: SortingState = .name {
        didSet {
            sortButton.setTitle(sortingState.description, for: .normal)
        }
    }

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setTitle(sortingState.description, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.setImage(UIImage(systemName: Constants.trashImage), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.sizeToFit()
        button.addTarget(self, action: #selector(sortingDidTap), for: .touchUpInside)
        return button
    }()

    private func configure() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        contentView.addSubview(sortButton)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortButton.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.sideInset),
            sortButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.sideInset),
        ])
    }

    @objc
    private func sortingDidTap() {
        delegate?.sortingDidTap()
    }
}
