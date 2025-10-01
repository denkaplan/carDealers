//
//  CollectionSectionDataSource.swift
//  Onfy
//
//  Created by Deniz Kaplan on 03/02/2023.
//

import RxRelay
import RxSwift

protocol CollectionSectionDataSource: AnyObject {
    var sectionIdentifier: AnyHashable { get }
    var sectionRelay: BehaviorRelay<CollectionSection> { get }
}

final class CollectionSectionDataSourceImpl: CollectionSectionDataSource {
    var sectionIdentifier: AnyHashable
    let sectionRelay: BehaviorRelay<CollectionSection>
    private let disposeBag = DisposeBag()

    init(
        _ section: CollectionSection
    ) {
        self.sectionIdentifier = section.id
        self.sectionRelay = BehaviorRelay<CollectionSection>(value: section)
    }
}
