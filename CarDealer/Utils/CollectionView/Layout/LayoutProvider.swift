//
//  LayoutProvider.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import UIKit

protocol CollectionLayoutProvider: AnyObject {
    /// Get section layout by index
    /// - Parameter index: index
    /// - Parameter environment: Layout environment
    /// - Returns: Section layout
    func layout(for index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?

    /// Set sections
    /// - Parameters:
    ///   - sections: Sections
    func set(sections: [_CollectionSection])

    var compositionalLayout: UICollectionViewCompositionalLayout? { get set }
    var interactionHandler: CollectionViewInteractionHandler? { get set }
}

final class LayoutProviderImpl: CollectionLayoutProvider {
    private var sections: [_CollectionSection] = []
    weak var compositionalLayout: UICollectionViewCompositionalLayout?
    weak var interactionHandler: CollectionViewInteractionHandler?

    func layout(for index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        if index >= sections.count {
            return nil
        }

        let section = sections[index]
        guard !section.items.isEmpty else { return nil }

        let sectionLayout: NSCollectionLayoutSection
        switch section.layout {
        case .table:
            sectionLayout = tableLayout(with: section, environment: environment)
        case .verticalGrid(let configuration):
            sectionLayout = verticalGridLayout(with: section, configuration: configuration, environment: environment)
        case .carousel(let configuration):
            sectionLayout = SectionLayout.Carousel.layout(with: section, configuration: configuration, environment: environment)
        case .fullWidthCarousel(let configuration):
            sectionLayout = SectionLayout.FullWidthCarousel.layout(with: section, configuration: configuration, environment: environment)
        case .gridCarousel(let configuration):
            sectionLayout = SectionLayout.GridCarousel.layout(with: section, configuration: configuration, environment: environment)
        case .patternGrid(let configuration):
            sectionLayout = SectionLayout.PatternGrid.layout(with: section, configuration: configuration, environment: environment)
        case .custom(let customLayout):
            sectionLayout = customLayout
        }
        if let background = section.configuration.background {
            compositionalLayout?.register(
                background.viewClass,
                forDecorationViewOfKind: background.reuseIdentifier
            )
            sectionLayout.decorationItems = [
                .background(elementKind: background.reuseIdentifier)
            ]
        }

        let handler = sectionLayout.visibleItemsInvalidationHandler
        sectionLayout.visibleItemsInvalidationHandler = { [weak self] items, point, environment in
            self?.interactionHandler?.interactionRelay.accept(Void())
            handler?(items, point, environment)
        }

        return sectionLayout
    }

    func set(sections: [_CollectionSection]) {
        self.sections = sections
    }

    private func tableLayout(
        with section: _CollectionSection,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        let items = section.items
        let layoutItems: [NSCollectionLayoutItem] = items.map { item in
            let layoutItem = NSCollectionLayoutItem(layoutSize: item.item.size)
            layoutItem.contentInsets = item.item.contentInsets
            return layoutItem
        }
        let contentHeight = layoutItems
            .map { $0.layoutSize.heightDimension.dimension }
            .reduce(0, +)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(contentHeight)),
            subitems: layoutItems
        )
        group.interItemSpacing = section.configuration.itemSpacing

        let layoutSection = NSCollectionLayoutSection(group: group)
        layoutSection.interGroupSpacing = section.configuration.groupSpacing
        layoutSection.contentInsets = section.configuration.contentInsets
        layoutSection.orthogonalScrollingBehavior = section.configuration.scrollingBehavior
        layoutSection.addHeaderFooterSupplementaryItems(with: section)
        return layoutSection
    }

    private func verticalGridLayout(
        with section: _CollectionSection,
        configuration: SectionLayout.GridConfiguration,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        let groupCount = CGFloat(configuration.groupCount)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / groupCount),
            heightDimension: .fractionalHeight(1.0)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = configuration.itemContentInsets

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(
                configuration.itemHeight.dimension
                    + configuration.itemContentInsets.verticalInset
                    + configuration.groupContentInsets.verticalInset
            )
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
        group.contentInsets = configuration.groupContentInsets

        let layoutSection = NSCollectionLayoutSection(group: group)
        layoutSection.interGroupSpacing = section.configuration.groupSpacing
        layoutSection.contentInsets = section.configuration.contentInsets
        layoutSection.orthogonalScrollingBehavior = section.configuration.scrollingBehavior
        layoutSection.addHeaderFooterSupplementaryItems(with: section)
        return layoutSection
    }
}

extension NSCollectionLayoutSection {
    func addHeaderFooterSupplementaryItems(with section: _CollectionSection) {
        if let header = section.header?.item as? any HeaderFooterItem {
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: header.size,
                elementKind: header.kind.rawValue,
                alignment: header.alignment,
                absoluteOffset: .zero
            )
            sectionHeader.contentInsets = header.contentInsets
            sectionHeader.pinToVisibleBounds = header.pinToVisibleBounds
            boundarySupplementaryItems.append(sectionHeader)
        }

        if let footer = section.footer?.item as? any HeaderFooterItem {
            let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footer.size,
                elementKind: footer.kind.rawValue,
                alignment: footer.alignment,
                absoluteOffset: .zero
            )
            sectionFooter.contentInsets = footer.contentInsets
            sectionFooter.pinToVisibleBounds = footer.pinToVisibleBounds
            boundarySupplementaryItems.append(sectionFooter)
        }

        section.supplementaryItems?.forEach {
            let layoutItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: $0.item.size,
                elementKind: $0.item.kind.rawValue,
                alignment: $0.item.alignment
            )
            layoutItem.contentInsets = $0.item.contentInsets
            boundarySupplementaryItems.append(layoutItem)
        }
    }
}
