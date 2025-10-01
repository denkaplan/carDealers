//
//  HeaderFooterItem.swift
//  Onfy
//
//  Created by Deniz Kaplan on 23/12/2022.
//

protocol HeaderFooterItem: CollectionItem {
    var pinToVisibleBounds: Bool { get }
}

extension HeaderFooterItem {
    var pinToVisibleBounds: Bool { false }
    var kind: CollectionItemKind { .sectionHeader }
}
