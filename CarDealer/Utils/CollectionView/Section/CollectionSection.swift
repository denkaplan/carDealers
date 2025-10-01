//
//  CollectionSection.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

struct CollectionSection {
    var id: AnyHashable
    var layout: SectionLayout
    var items: [any CollectionItem]
    var header: (any HeaderFooterItem)?
    var footer: (any HeaderFooterItem)?
    var supplementaryItems: [any CollectionItem]?
    var configuration: Configuration

    init(
        id: AnyHashable,
        layout: SectionLayout,
        items: [any CollectionItem],
        header: (any HeaderFooterItem)? = nil,
        footer: (any HeaderFooterItem)? = nil,
        supplementaryItems: [any CollectionItem]? = nil,
        configuration: Configuration = .default
    ) {
        self.id = id
        self.layout = layout
        self.items = items
        self.header = header
        self.footer = footer
        self.supplementaryItems = supplementaryItems
        self.configuration = configuration
    }
}
