//
//  CollectionSectionAggregatorImpl.swift
//  Onfy
//
//  Created by Deniz Kaplan on 06/02/2023.
//

import RxRelay
import RxSwift
import UIKit

final class CollectionSectionAggregatorImpl {
    private let sections = BehaviorRelay<[CollectionSection]>(value: [])
    private var dataSources = [Int: CollectionSectionDataSource]()
    private let disposeBag = DisposeBag()
}

// MARK: CollectionSectionAggregator

extension CollectionSectionAggregatorImpl: CollectionSectionAggregator {
    var sectionsObservable: Observable<[CollectionSection]> { sections.asObservable() }

    func start() {
        // swiftlint:disable syntactic_sugar
        let sectionsObservables = dataSources.reduce(
            into: Array<Observable<CollectionSection>>(repeating: .empty(), count: dataSources.count)
        ) { partialResult, tuple in
            partialResult[tuple.key] = tuple.value.sectionRelay.asObservable().skip(while: { $0.items.isEmpty })
        }
        // swiftlint:enable syntactic_sugar

        Observable.combineLatest(
            sectionsObservables
        )
        .bind(to: sections)
        .disposed(by: disposeBag)
    }

    func register(dataSource: CollectionSectionDataSource, prefferedIndex: Int) {
        #if DEBUG
        if dataSources[prefferedIndex] != nil {
            preconditionFailure("DataSource at index:\(prefferedIndex) already exist")
        }
        #endif
        dataSources[prefferedIndex] = dataSource
    }
}
