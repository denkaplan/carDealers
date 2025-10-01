//
//  CollectionItemKind.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

enum CollectionItemKind: String, Equatable {
    case cell = "cell-kind"
    case badge = "badge-element-kind"
    case background = "background-element-kind"
    case sectionHeader = "section-header-element-kind"
    case sectionFooter = "section-footer-element-kind"
    case layoutHeader = "layout-header-element-kind"
    case layoutFooter = "layout-footer-element-kind"
}
