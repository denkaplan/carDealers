//
//  _CollectionItem.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import Foundation

// swiftlint:disable type_name
struct _CollectionItem {
    let item: any CollectionItem

    init(_ item: some CollectionItem) {
        self.item = item
    }
}

extension _CollectionItem: Differentiable {
    var differenceIdentifier: AnyHashable { item.equality }

    func isContentEqual(to source: _CollectionItem) -> Bool {
        item.equality == source.item.equality
    }
}
// swiftlint:enable type_name
