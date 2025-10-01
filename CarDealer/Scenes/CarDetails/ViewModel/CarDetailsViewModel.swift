//
//  CarDetailsViewModel.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 22.02.24.
//

import RxSwift
import RxRelay
import Foundation

final class CarDetailsViewModel: CarDetailsViewModelProtocol {
    init(carViewModel: CarViewModel) {
        viewData = .init(carViewModel: carViewModel)
    }

    var input: CarDetailsViewModelInput = .init()
    private(set) lazy var output: CarDetailsViewModelOutput = .init()
    var viewActions: CarDetailsViewModelViewActions = .init()
    var viewData: CarDetailsViewModelViewData
}
