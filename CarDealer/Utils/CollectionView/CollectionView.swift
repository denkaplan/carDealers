//
//  CollectionView.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import RxRelay
import RxSwift
import UIKit

final class CollectionView: UICollectionView {
    // MARK: Public Properties

    ///  When scrolled main content or any section
    var interactionObervable: Observable<Void> {
        interactionHandler.interactionRelay.asObservable()
    }

    weak var scrollViewDelegate: UIScrollViewDelegate?
    weak var collectionViewDelegate: UICollectionViewDelegate?

    // MARK: Private

    private let interactionHandler: CollectionViewInteractionHandler = CollectionViewInteractionHandlerImpl()
    private let sectionConverter: SectionConverter = SectionConverterImpl()
    private lazy var logic: CollectionDataSource = BatchUpdatesDataSource(collectionView: self)
    private let layoutProvider: CollectionLayoutProvider = LayoutProviderImpl()
    private lazy var layout = CompositionalLayout(layoutProvider: layoutProvider)

    // MARK: Public interface

    func set(sections: [CollectionSection], animatingDifferences: Bool, completion: (() -> Void)? = nil) {
        self.sections = sections
        let sections = sectionConverter.convert(from: sections)
        logic.set(
            sections: sections,
            layoutProvider: layoutProvider,
            animatingDifferences: animatingDifferences,
            completion: completion
        )
    }

    private(set) var sections = [CollectionSection]()

    func indexOfSection(_ identifier: AnyHashable) -> Int? {
        sections.firstIndex(where: { $0.id == identifier })
    }

    func updateLayout() {
        performBatchUpdates({})
    }

    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        translatesAutoresizingMaskIntoConstraints = false
        logic.interactionHandler = interactionHandler
        delegate = logic
        dataSource = logic
        collectionViewLayout = layout
        layoutProvider.compositionalLayout = layout
        layoutProvider.interactionHandler = interactionHandler
        backgroundColor = .clear
    }

    private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        preconditionFailure("Unavailable")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
}
