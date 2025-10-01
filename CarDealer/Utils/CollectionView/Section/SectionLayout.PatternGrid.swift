//
//  SectionLayout.PatternGrid.swift
//  Onfy
//
//  Created by Evgenii Egorov on 17.03.2023.
//  Copyright © 2023 Joom Pharmacy. All rights reserved.
//

import UIKit

extension SectionLayout {
    struct PatternGrid {
        struct Configuration {
            var columnCount: Int
            var pattern: [Int] = [1]
            var height: CGFloat?
            var spacing: CGFloat
        }

        static func layout(
            with section: _CollectionSection,
            configuration: Configuration,
            environment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection {
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(configuration.height ?? 100)
            )
            let group = NSCollectionLayoutGroup.custom(layoutSize: groupSize) { environment in
                let contentSize = environment.container.contentSize
                let xInset = section.configuration.contentInsets.leading + section.configuration.contentInsets.trailing
                let size = CGSize(width: contentSize.width - xInset, height: contentSize.height)
                let columnCount = configuration.columnCount
                let spacing = configuration.spacing
                let itemWidth = (size.width - spacing * CGFloat(columnCount - 1)) / CGFloat(columnCount)
                let itemHeight = configuration.height ?? itemWidth
                let pattern = configuration.pattern.isEmpty ? [1] : configuration.pattern
                var column = 0
                var row = 0
                return section.items.enumerated().map { index, item -> NSCollectionLayoutGroupCustomItem in
                    let columnWidth = min(configuration.pattern[index % pattern.count], columnCount)
                    let width = CGFloat(columnWidth) * itemWidth + CGFloat(columnWidth - 1) * spacing
                    if column + columnWidth > columnCount {
                        row += 1
                        column = 0
                    }
                    let x = CGFloat(column) * itemWidth + CGFloat(column) * spacing
                    let y = CGFloat(row) * itemHeight + CGFloat(row) * spacing
                    column += columnWidth
                    let frame = CGRect(x: x, y: y, width: width, height: itemHeight)
                    return NSCollectionLayoutGroupCustomItem(frame: frame)
                }
            }

            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.contentInsets = section.configuration.contentInsets
            layoutSection.addHeaderFooterSupplementaryItems(with: section)
            return layoutSection
        }
    }
}
