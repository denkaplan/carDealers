//
//  SectionConverter.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import Foundation

protocol SectionConverter {
    func convert(from sections: [CollectionSection]) -> [_CollectionSection]
}

final class SectionConverterImpl {
    private let separatorStrategy: SeparatorStrategy

    convenience init() {
        self.init(separatorStrategy: DefaultSeparatorStrategy())
    }

    init(separatorStrategy: SeparatorStrategy) {
        self.separatorStrategy = separatorStrategy
    }
}

extension SectionConverterImpl: SectionConverter {
    func convert(from sections: [CollectionSection]) -> [_CollectionSection] {
        var output = [_CollectionSection]()
        for section in sections {
            let separetedItems: [any CollectionItem]
            let style = section.configuration.separator
            switch style {
            case .none: separetedItems = section.items
            case .line(let insets):
                separetedItems = separatorStrategy.fillSeparators(
                    items: section.items,
                    insets: insets
                )
            }
            // crash if SectionConfiguration is a struct (Thread 1: EXC_BAD_ACCESS (code=1, address=0x86))
            output.append(
                _CollectionSection(
                    id: section.id,
                    layout: section.layout,
                    items: separetedItems.map { _CollectionItem($0) },
                    configuration: section.configuration,
                    supplementaryItems: section.supplementaryItems?.map { _CollectionItem($0) },
                    header: section.header.map { _CollectionItem($0) },
                    footer: section.footer.map { _CollectionItem($0) }
                )
            )
        }
        return output
    }
}
