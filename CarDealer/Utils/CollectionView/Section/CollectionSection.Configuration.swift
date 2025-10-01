//
//  CollectionSection.Configuration.swift
//  Onfy
//
//  Created by Deniz Kaplan on 10/01/2023.
//

import UIKit

extension CollectionSection {
    struct Configuration {
        let separator: Separator
        let contentInsets: NSDirectionalEdgeInsets
        let groupSpacing: CGFloat
        let scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
        let itemSpacing: NSCollectionLayoutSpacing?
        let background: Background?

        init(
            separator: Separator = .none,
            contentInsets: NSDirectionalEdgeInsets = .zero,
            groupSpacing: CGFloat = .zero,
            scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none,
            itemSpacing: NSCollectionLayoutSpacing? = nil,
            background: Background? = nil
        ) {
            self.separator = separator
            self.contentInsets = contentInsets
            self.groupSpacing = groupSpacing
            self.scrollingBehavior = scrollingBehavior
            self.itemSpacing = itemSpacing
            self.background = background
        }
    }
}

// MARK: Nested Types

extension CollectionSection.Configuration {
    enum Separator {
        case none
        case line(NSDirectionalEdgeInsets)
    }
}

// MARK: Factories

extension CollectionSection.Configuration {
    static let `default` = CollectionSection.Configuration()
}
