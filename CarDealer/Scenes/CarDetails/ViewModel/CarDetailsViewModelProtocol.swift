//
//  CarDetailsViewModelProtocol.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 23.02.24.
//

import RxSwift
import RxRelay

internal struct CarDetailsViewModelInput {}

internal struct CarDetailsViewModelOutput {}

internal struct CarDetailsViewModelViewActions {
    let didTapCarRow: PublishRelay<String> = .init()
}

internal struct CarDetailsViewModelViewData {
    let carViewModel: CarViewModel
}

internal protocol CarDetailsViewModelInputOutput {
    var input: CarDetailsViewModelInput { get }
    var output: CarDetailsViewModelOutput { get }
}

internal protocol CarDetailsViewModelViewActionsAndData {
    var viewActions: CarDetailsViewModelViewActions { get }
    var viewData: CarDetailsViewModelViewData { get }
}

internal typealias CarDetailsViewModelProtocol = CarDetailsViewModelInputOutput
    & CarDetailsViewModelViewActionsAndData
