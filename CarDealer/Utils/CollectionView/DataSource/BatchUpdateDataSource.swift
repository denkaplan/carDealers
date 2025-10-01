//
//  BatchUpdateDataSource.swift
//  Onfy
//
//  Created by Deniz Kaplan on 22/12/2022.
//

import UIKit

final class BatchUpdatesDataSource: NSObject {
    weak var interactionHandler: CollectionViewInteractionHandler?
    private weak var collectionView: CollectionView?
    private var sections: [_CollectionSection] = []
    private var dequeuer = CollectionView.Dequeuer()

    init(collectionView: CollectionView) {
        self.collectionView = collectionView
    }
}

// MARK: CollectionDataSource

extension BatchUpdatesDataSource: CollectionDataSource {
    func set(
        sections: [_CollectionSection],
        layoutProvider: CollectionLayoutProvider,
        animatingDifferences: Bool,
        completion: (() -> Void)?
    ) {
        guard animatingDifferences, let collectionView else {
            self.sections = sections
            layoutProvider.set(sections: sections)
            collectionView?.reloadData()
            completion?()
            return
        }

        let stagedChangeset = StagedChangeset(source: self.sections, target: sections)

        for (index, changeset) in stagedChangeset.changesets.enumerated() {
            collectionView.performBatchUpdates(
                _: {
                    self.sections = changeset.data
                    layoutProvider.set(sections: changeset.data)

                    if !changeset.sectionDeleted.isEmpty {
                        collectionView.deleteSections(IndexSet(changeset.sectionDeleted))
                    }
                    if !changeset.sectionInserted.isEmpty {
                        collectionView.insertSections(IndexSet(changeset.sectionInserted))
                    }
                    if !changeset.sectionUpdated.isEmpty {
                        collectionView.reloadSections(IndexSet(changeset.sectionUpdated))
                    }
                    for (source, target) in changeset.sectionMoved {
                        collectionView.moveSection(source, toSection: target)
                    }
                    if !changeset.elementDeleted.isEmpty {
                        collectionView.deleteItems(at: changeset.elementDeleted.map { IndexPath(item: $0.element, section: $0.section) })
                    }
                    if !changeset.elementInserted.isEmpty {
                        collectionView.insertItems(at: changeset.elementInserted.map {
                            IndexPath(item: $0.element, section: $0.section)
                        })
                    }
                    if !changeset.elementUpdated.isEmpty {
                        collectionView.reloadItems(at: changeset.elementUpdated.map {
                            IndexPath(item: $0.element, section: $0.section)
                        })
                    }
                    for (source, target) in changeset.elementMoved {
                        collectionView.moveItem(
                            at: IndexPath(item: source.element, section: source.section),
                            to: IndexPath(item: target.element, section: target.section)
                        )
                    }
                },
                completion: index != stagedChangeset.changesets.count - 1 ? nil : { _ in completion?() }
            )
        }
    }
}

// MARK: UICollectionDataSource & UICollectionViewDelegate

extension BatchUpdatesDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.item].item
        let cell = dequeuer.dequeue(item: item, for: indexPath, in: collectionView)
        if case let .table(configuration) = section.layout {
            if case let .rounded(cornerRadius) = configuration.style {
                var maskedCorners: CACornerMask = []
                if indexPath.item == 0 {
                    maskedCorners.formUnion([.layerMaxXMinYCorner, .layerMinXMinYCorner])
                }
                if indexPath.item == section.items.count - 1 {
                    maskedCorners.formUnion([.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
                }
                cell.contentView.layer.cornerRadius = cornerRadius
                cell.contentView.layer.maskedCorners = maskedCorners
                cell.contentView.layer.masksToBounds = true
            }
        }
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == CollectionItemKind.sectionHeader.rawValue {
            guard let sectionHeader = sections[indexPath.section].header?.item else {
                preconditionFailure("Can't find header for section at \(indexPath)")
            }
            return dequeuer.dequeue(supplementaryItem: sectionHeader, for: indexPath, in: collectionView)
        }
        if kind == CollectionItemKind.sectionFooter.rawValue {
            guard let sectionFooter = sections[indexPath.section].footer?.item else {
                preconditionFailure("Can't find footer for section at \(indexPath)")
            }
            return dequeuer.dequeue(supplementaryItem: sectionFooter, for: indexPath, in: collectionView)
        }

        guard
            let supplementary = sections[indexPath.section].supplementaryItems?.first(where: { $0.item.kind.rawValue == kind })
        else {
            preconditionFailure("Can't find supplementary item of \(kind) for section at \(indexPath)")
        }

        return dequeuer.dequeue(supplementaryItem: supplementary.item, for: indexPath, in: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = sections[indexPath.section].items[indexPath.item].item as? any TapableCollectionItem else { return }
        item.itemDidTapped()
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.collectionView?.collectionViewDelegate?.collectionView?(
            collectionView,
            willDisplay: cell,
            forItemAt: indexPath
        )
    }
}

// MARK: UIScrollViewDelegate

extension BatchUpdatesDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView?.scrollViewDelegate?.scrollViewDidScroll?(scrollView)
        interactionHandler?.interactionRelay.accept(Void())
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        collectionView?.scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionView?.scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
         collectionView?.scrollViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        collectionView?.scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        collectionView?.scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        collectionView?.scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        collectionView?.scrollViewDelegate?.scrollViewWillEndDragging?(
            scrollView,
            withVelocity: velocity,
            targetContentOffset: targetContentOffset
        )
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        collectionView?.scrollViewDelegate?.scrollViewDidZoom?(scrollView)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        collectionView?.scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
}
