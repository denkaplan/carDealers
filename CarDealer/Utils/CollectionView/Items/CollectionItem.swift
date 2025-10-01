//
//  CollectionItem.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import UIKit

protocol CollectionItem<View, ViewModel> {
    associatedtype View: ContentView where View.ViewModel == Self.ViewModel
    associatedtype ViewModel

    var viewModel: ViewModel { get }
    var comparator: Comparator<Self.ViewModel>? { get }

    var kind: CollectionItemKind { get }
    var size: NSCollectionLayoutSize { get }
    var contentInsets: NSDirectionalEdgeInsets { get }
    var alignment: NSRectAlignment { get }
}

// MARK: Hashable

extension CollectionItem {
    var equality: AnyHashable {
        comparator?.result ?? AnyHashable(0)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.equality == rhs.equality
    }
}

// MARK: Default implementation

extension CollectionItem {
    var kind: CollectionItemKind { .cell }
    var size: NSCollectionLayoutSize { .fullWidth }
    var contentInsets: NSDirectionalEdgeInsets { .zero }
    var alignment: NSRectAlignment { .none }
}

// MARK: Helpers

extension CollectionItem {
    var reusableViewClass: AnyClass? {
        guard kind != .cell else {
            return CollectionCell<Self.View>.self
        }
        return CollectionReusableView<Self.View>.self
    }

    var reuseIdentifier: String {
        kind.rawValue + "." + String(reflecting: self)
    }
}
