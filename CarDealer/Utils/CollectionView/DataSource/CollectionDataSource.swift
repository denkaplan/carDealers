//
//  CollectionDataSource.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import UIKit

protocol CollectionDataSource: UICollectionViewDelegate, UICollectionViewDataSource {
    func set(
        sections: [_CollectionSection],
        layoutProvider: CollectionLayoutProvider,
        animatingDifferences: Bool,
        completion: (() -> Void)?
    )

    var interactionHandler: CollectionViewInteractionHandler? { get set }
}
