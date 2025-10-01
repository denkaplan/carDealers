//
//  SeparatorStrategy.swift
//  Onfy
//
//  Created by Deniz Kaplan on 23/12/2022.
//

import UIKit

protocol SeparatorStrategy {
    func fillSeparators(
        items: [any CollectionItem],
        insets: NSDirectionalEdgeInsets
    ) -> [any CollectionItem]
}
