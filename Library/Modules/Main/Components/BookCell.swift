//
//  BookCell.swift
//  Library
//
//  Created by Maxim on 22.10.2024.
//

import UIKit

final class BookCell: UITableViewCell {

    private enum Constants {
        static let stackSpacing: CGFloat = 8
        static let stackInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        book = nil
    }

    var book: BookModel? {
        didSet {
            nameLabel.text = book?.name
            authorLabel.text = book?.author
            dateLabel.text = book?.date
        }
    }

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, authorLabel, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constants.stackSpacing
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constants.stackInsets
        return stackView
    }()

    private lazy var nameLabel: UILabel = makeLabel()

    private lazy var authorLabel: UILabel = makeLabel()

    private lazy var dateLabel: UILabel = makeLabel()

    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }

    private func configure() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            contentStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
