//
//  CollectionCell.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import UIKit

final class CollectionCell<View: ContentView>: UICollectionViewCell {
    private let view = View()

    override init(frame: CGRect) {
        super.init(frame: frame)

        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        view.prepareForReuse()
    }

    override var isSelected: Bool {
        didSet {
            view.setSelected(isSelected)
        }
    }

    override var isHighlighted: Bool {
        didSet {
            view.setHighlighted(isHighlighted)
        }
    }

    func bind(with viewModel: View.ViewModel) {
        view.bind(with: viewModel)
    }
}
