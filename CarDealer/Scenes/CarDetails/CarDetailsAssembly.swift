//
//  CarDetailsAssembly.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 22.02.24.
//

import UIKit

final class CarDetailsAssembly {
    struct Dependency {
        let input: CarViewModel
    }

    let view: CarDetailsViewController
    let viewModel: CarDetailsViewModelInputOutput

    init(_ dependency: Dependency) {
        let viewModel = CarDetailsViewModel(carViewModel: dependency.input)
        let viewController = CarDetailsViewController(viewModel)
        self.view = viewController
        self.viewModel = viewModel
    }
}
