//
//  CollectionSection.Layout.Grid.swift
//  Onfy
//
//  Created by Deniz Kaplan on 10/01/2023.
//

import UIKit

extension SectionLayout {
    /// Configuration of Grid Layout
    struct GridConfiguration {
        /// Number of equal rows
        let groupCount: Int
        /// Inset of each line
        let groupContentInsets: NSDirectionalEdgeInsets
        /// Grid item height
        let itemHeight: NSCollectionLayoutDimension
        /// Inset of item
        let itemContentInsets: NSDirectionalEdgeInsets
    }
}

// MARK: Values

extension SectionLayout.GridConfiguration {
    static let twoRowsHeight280 = SectionLayout.GridConfiguration(
        groupCount: 2,
        groupContentInsets: .init(top: 8, leading: 8, bottom: 8, trailing: 8),
        itemHeight: .absolute(280),
        itemContentInsets: .init(top: 0, leading: 8, bottom: 0, trailing: 8)
    )
}
