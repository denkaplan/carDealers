//
//  SectionLayout.Carousel.swift
//  Onfy
//
//  Created by Evgenii Egorov on 20.03.2023.
//  Copyright © 2023 Joom Pharmacy. All rights reserved.
//

import UIKit

extension SectionLayout {
    struct Carousel {
        struct Configuration {
            var width: NSCollectionLayoutDimension?
            var spacing: CGFloat
            var paging: Bool
        }

        static func layout(
            with section: _CollectionSection,
            configuration: Configuration,
            environment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection {
            let layoutItems = section.items.map { item in
                let width = configuration.width != nil ? .fractionalWidth(1.0) : item.item.size.widthDimension
                let size = NSCollectionLayoutSize(widthDimension: width, heightDimension: item.item.size.heightDimension)
                return NSCollectionLayoutItem(layoutSize: size)
            }
            let contentHeight = layoutItems.map(\.layoutSize.heightDimension.dimension).max() ?? 100
            let width = configuration.width
                ?? layoutItems.first?.layoutSize.widthDimension
                ?? .estimated(environment.container.effectiveContentSize.width)
            let size = NSCollectionLayoutSize(widthDimension: width, heightDimension: .estimated(contentHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: layoutItems)
            group.interItemSpacing = .fixed(configuration.spacing)

            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.contentInsets = section.configuration.contentInsets
            layoutSection.orthogonalScrollingBehavior = configuration.paging ? .groupPaging : .continuous
            layoutSection.interGroupSpacing = configuration.spacing
            layoutSection.addHeaderFooterSupplementaryItems(with: section)
            return layoutSection
        }
    }

    struct FullWidthCarousel {
        struct Configuration {
            var spacing: CGFloat
            var paging: Bool
        }

        static func layout(
            with section: _CollectionSection,
            configuration: Configuration,
            environment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection {
            let height = section.items.map(\.item.size.heightDimension.dimension).max() ?? 100
            let insets = section.configuration.contentInsets
            let width = environment.container.contentSize.width - insets.leading - insets.trailing
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(width), heightDimension: .estimated(height))
            let group = NSCollectionLayoutGroup.custom(layoutSize: groupSize) { environment in
                let size = environment.container.contentSize
                let spacing = configuration.spacing
                return section.items.enumerated().map { index, item -> NSCollectionLayoutGroupCustomItem in
                    let x = CGFloat(index) * size.width + CGFloat(index) * spacing
                    let frame = CGRect(x: x, y: 0, width: size.width, height: size.height)
                    return NSCollectionLayoutGroupCustomItem(frame: frame)
                }
            }

            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.contentInsets = insets
            layoutSection.orthogonalScrollingBehavior = configuration.paging ? .groupPaging : .continuous
            layoutSection.interGroupSpacing = configuration.spacing
            layoutSection.addHeaderFooterSupplementaryItems(with: section)
            return layoutSection
        }
    }

    struct GridCarousel {
        struct Configuration {
            var columnCount: Int
            var spacing: CGFloat
            var paging: Bool
            var pageTracker: ((_ page: Int) -> Void)?
        }

        static func layout(
            with section: _CollectionSection,
            configuration: Configuration,
            environment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection {
            let height = section.items.map(\.item.size.heightDimension.dimension).max() ?? 100
            let insets = section.configuration.contentInsets
            let width = environment.container.contentSize.width - insets.leading - insets.trailing
            let groupSpacing = configuration.paging ? insets.trailing : configuration.spacing
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(width), heightDimension: .estimated(height))
            let group = NSCollectionLayoutGroup.custom(layoutSize: groupSize) { environment in
                let spacing = configuration.spacing
                let itemWidth = (width - spacing * CGFloat(configuration.columnCount - 1)) / CGFloat(configuration.columnCount)
                let size = CGSize(width: itemWidth, height: environment.container.contentSize.height)
                var x: CGFloat = 0
                // swiftlint:disable legacy_multiple
                return section.items.enumerated().map { index, item -> NSCollectionLayoutGroupCustomItem in
                    let frame = CGRect(x: x, y: 0, width: size.width, height: size.height)
                    let itemSpacing = (index + 1) % configuration.columnCount == 0 ? groupSpacing : spacing
                    x += size.width + itemSpacing
                    return NSCollectionLayoutGroupCustomItem(frame: frame)
                }
            }
            // swiftlint:enable legacy_multiple

            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.contentInsets = insets
            layoutSection.orthogonalScrollingBehavior = configuration.paging ? .groupPaging : .continuous
            layoutSection.interGroupSpacing = groupSpacing
            layoutSection.addHeaderFooterSupplementaryItems(with: section)
            if let pageTracker = configuration.pageTracker {
                var currentPage = -1
                layoutSection.visibleItemsInvalidationHandler = { items, point, environment in
                    let width = environment.container.contentSize.width - insets.leading
                    let page = Int((point.x + width / 2) / width)
                    if currentPage != page {
                        pageTracker(page)
                        currentPage = page
                    }
                }
            }
            return layoutSection
        }
    }
}
