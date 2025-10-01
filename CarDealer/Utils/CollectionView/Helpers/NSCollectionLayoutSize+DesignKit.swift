//
//  NSCollectionLayoutSize+DesignKit.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import UIKit

extension NSCollectionLayoutSize {
    static let fullWidth: NSCollectionLayoutSize =
        .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(40))

    static func fullWidth(_ height: CGFloat) -> NSCollectionLayoutSize {
        .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(height))
    }
}
