//
//  CompositionalLayout.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import UIKit

final class CompositionalLayout: UICollectionViewCompositionalLayout {
    init(layoutProvider: CollectionLayoutProvider) {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        super.init(
            sectionProvider: { [weak layoutProvider] sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
                layoutProvider?.layout(for: sectionIndex, environment: layoutEnvironment)
            },
            configuration: configuration
        )
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
}
