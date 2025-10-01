//
//  SeparatorItem.swift
//  Onfy
//
//  Created by Deniz Kaplan on 23/12/2022.
//

import UIKit

struct SeparatorItem {
    let contentInsets: NSDirectionalEdgeInsets
    let viewModel = ViewModel()
}

extension SeparatorItem: CollectionItem {
    typealias View = Cell

    var comparator: Comparator<ViewModel>? {
        .init(model: viewModel)
    }

    var size: NSCollectionLayoutSize {
        .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(1 / UIScreen.main.scale)
        )
    }
}

// MARK: Nested Types

extension SeparatorItem {
    struct ViewModel {}

    final class Cell: UIView {
        var isSelected: Bool = false
        var isHighlighted: Bool = false

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupUI()
        }

        required init?(coder: NSCoder) {
            fatalError("")
        }

        private func setupUI() {
            backgroundColor = .separator
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

extension SeparatorItem.Cell: ContentView {
    typealias ViewModel = SeparatorItem.ViewModel
    func bind(with viewModel: SeparatorItem.ViewModel) {}
}
