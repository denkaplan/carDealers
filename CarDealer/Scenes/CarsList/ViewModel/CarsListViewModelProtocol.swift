//
//  CarsListViewModelProtocol.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 23.02.24.
//

import RxSwift
import RxRelay

internal struct CarsListViewModelInput {
}

internal struct CarsListViewModelOutput {
    let didSelectCar: Observable<CarViewModel>
}

internal struct CarsListViewModelViewActions {
    let viewDidLoad = PublishRelay<Void>()
    let searchInput = BehaviorRelay<String?>(value: nil)
}

internal struct CarsListViewModelViewData {
    let sections = BehaviorRelay<[CollectionSection]>(value: [])
}

internal protocol CarsListViewModelInputOutput {
    var input: CarsListViewModelInput { get }
    var output: CarsListViewModelOutput { get }
}

internal protocol CarsListViewModelViewActionsAndData {
    var viewActions: CarsListViewModelViewActions { get }
    var viewData: CarsListViewModelViewData { get }
}

internal typealias CarsListViewModelProtocol = CarsListViewModelInputOutput
    & CarsListViewModelViewActionsAndData
