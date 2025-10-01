//
//  Dequeuer.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import UIKit

extension CollectionView {
    struct Dequeuer {
        private var identifiers = Set<String>()

        mutating func dequeue<T: CollectionItem>(
            item: T,
            for indexPath: IndexPath,
            in collectionView: UICollectionView
        ) -> UICollectionViewCell {
            typealias Cell = CollectionCell<T.View>
            let reuseIdentifier = registerCell(
                with: item,
                in: collectionView
            )
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            )

            guard let cell = cell as? Cell else {
                preconditionFailure("Can't cast dequeued cell with id \(reuseIdentifier) from \(type(of: cell)) to \(Cell.self)")
            }

            cell.bind(with: item.viewModel)
            return cell
        }

        mutating func dequeue<T: CollectionItem>(
            supplementaryItem: T,
            for indexPath: IndexPath,
            in collectionView: UICollectionView
        ) -> UICollectionReusableView {
            typealias AnyView = CollectionReusableView<T.View>
            let reuseIdentifier = registerView(
                with: supplementaryItem,
                in: collectionView
            )
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: supplementaryItem.kind.rawValue,
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            )

            guard let view = view as? AnyView else {
                preconditionFailure("Can't cast dequeued view with id \(reuseIdentifier) from \(type(of: view)) to \(AnyView.self)")
            }

            view.bind(with: supplementaryItem.viewModel)
            return view
        }
    }
}

private extension CollectionView.Dequeuer {
    mutating func registerCell(
        with item: some CollectionItem,
        in collectionView: UICollectionView
    ) -> String {
        let reuseIdentifier = item.reuseIdentifier
        guard !identifiers.contains(reuseIdentifier) else { return reuseIdentifier }
        collectionView.register(
            item.reusableViewClass,
            forCellWithReuseIdentifier: reuseIdentifier
        )
        identifiers.insert(reuseIdentifier)
        return reuseIdentifier
    }

    mutating func registerView(
        with supplementaryItem: some CollectionItem,
        in collectionView: UICollectionView
    ) -> String {
        let reuseIdentifier = supplementaryItem.reuseIdentifier
        guard !identifiers.contains(reuseIdentifier) else { return reuseIdentifier }
        collectionView.register(
            supplementaryItem.reusableViewClass,
            forSupplementaryViewOfKind: supplementaryItem.kind.rawValue,
            withReuseIdentifier: reuseIdentifier
        )
        identifiers.insert(reuseIdentifier)
        return reuseIdentifier
    }
}
