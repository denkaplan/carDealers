//
//  SupplementaryItem.swift
//  Onfy
//
//  Created by Deniz Kaplan on 10/01/2023.
//

import UIKit

protocol SupplementaryItem<View> {
    associatedtype View: SupplementaryView where View.Item == Self

    var kind: CollectionItemKind { get }
    var alignment: NSRectAlignment { get }
}

protocol SupplementaryView: UIView {
    associatedtype Item

    func bind(with item: Item)
}

extension SupplementaryItem {
    var kind: CollectionItemKind { .background }
    var alignment: NSRectAlignment { .none }
}

// MARK: Helpers

extension SupplementaryItem {
    var reusableViewClass: AnyClass? {
        SupplementaryReusableView<Self.View>.self
    }

    var reuseIdentifier: String {
        kind.rawValue + "." + String(reflecting: self)
    }
}
