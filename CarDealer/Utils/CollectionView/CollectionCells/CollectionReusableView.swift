//
//  CollectionReusableView.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import UIKit

final class CollectionReusableView<View: ContentView>: UICollectionReusableView {
    private let view = View()

    override init(frame: CGRect) {
        super.init(frame: frame)

        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
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

    func bind(with viewModel: View.ViewModel) {
        view.bind(with: viewModel)
    }
}

final class SupplementaryReusableView<View: SupplementaryView>: UICollectionReusableView {
    private let view = View()

    override init(frame: CGRect) {
        super.init(frame: frame)

        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    func bind(with item: View.Item) {
        view.bind(with: item)
    }
}
