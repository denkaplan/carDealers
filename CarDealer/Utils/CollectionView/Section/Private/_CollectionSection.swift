//
//  _CollectionSection.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import UIKit

// swiftlint:disable:next type_name
struct _CollectionSection {
    let id: AnyHashable
    let layout: SectionLayout
    let items: [_CollectionItem]
    let supplementaryItems: [_CollectionItem]?
    let header: _CollectionItem?
    let footer: _CollectionItem?
    let configuration: CollectionSection.Configuration

    init(
        id: AnyHashable,
        layout: SectionLayout,
        items: [_CollectionItem],
        configuration: CollectionSection.Configuration,
        supplementaryItems: [_CollectionItem]?,
        header: _CollectionItem?,
        footer: _CollectionItem?
    ) {
        self.id = id
        self.layout = layout
        self.items = items
        self.configuration = configuration
        self.supplementaryItems = supplementaryItems
        self.header = header
        self.footer = footer
    }

    init<C: Swift.Collection>(
        identifier: AnyHashable,
        layout: SectionLayout,
        items: C,
        configuration: CollectionSection.Configuration,
        supplementaryItems: [_CollectionItem]?,
        header: _CollectionItem?,
        footer: _CollectionItem?
    ) where C.Element == _CollectionItem {
        self.id = identifier
        self.layout = layout
        self.items = items.compactMap { $0 }
        self.configuration = configuration
        self.supplementaryItems = supplementaryItems
        self.header = header
        self.footer = footer
    }

    init(section: CollectionSection) {
        self.id = section.id
        self.layout = section.layout
        self.items = section.items.map { _CollectionItem($0) }
        self.configuration = section.configuration
        self.supplementaryItems = section.supplementaryItems?.map { _CollectionItem($0) }
        self.header = section.header.map { _CollectionItem($0) }
        self.footer = section.footer.map { _CollectionItem($0) }
    }
}

// MARK: DifferentiableSection

extension _CollectionSection: DifferentiableSection {
    init<C: Swift.Collection>(source: _CollectionSection, elements: C) where C.Element == _CollectionItem {
        self.init(
            identifier: source.id,
            layout: source.layout,
            items: elements,
            configuration: source.configuration,
            supplementaryItems: source.supplementaryItems,
            header: source.header,
            footer: source.footer
        )
    }

    var elements: [_CollectionItem] { items }

    func isContentEqual(to source: _CollectionSection) -> Bool {
        header.isContentEqual(to: source.header) && footer.isContentEqual(to: source.footer)
    }

    var differenceIdentifier: some Hashable { id }
}
