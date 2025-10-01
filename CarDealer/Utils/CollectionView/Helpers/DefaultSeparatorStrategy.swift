//
//  DefaultSeparatorStrategy.swift
//  Onfy
//
//  Created by Deniz Kaplan on 23/12/2022.
//

import UIKit

/// All items except last have separators
final class DefaultSeparatorStrategy: SeparatorStrategy {
    func fillSeparators(
        items: [any CollectionItem],
        insets: NSDirectionalEdgeInsets
    ) -> [any CollectionItem] {
        let separator = SeparatorItem(contentInsets: insets)
        return items.enumerated().reduce(into: [any CollectionItem]()) { partialResult, tuple in
            let (index, item) = tuple
            partialResult.append(item)
            if index < items.count - 1 {
                partialResult.append(separator)
            }
        }
    }
}
