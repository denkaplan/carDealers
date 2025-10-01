//
//  CollectionSectionsAggregator.swift
//  Onfy
//
//  Created by Deniz Kaplan on 03/02/2023.
//

import RxSwift
import UIKit

protocol CollectionSectionAggregatable: AnyObject {
    var aggregator: CollectionSectionAggregator { get }
}

protocol CollectionSectionAggregator: AnyObject {
    var sectionsObservable: Observable<[CollectionSection]> { get }

    func start()

    func register(dataSource: CollectionSectionDataSource, prefferedIndex: Int)
}
