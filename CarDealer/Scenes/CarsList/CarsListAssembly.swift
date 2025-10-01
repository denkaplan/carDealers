//
//  CarsListAssembly.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 22.02.24.
//

import UIKit

final class CarsListAssembly {
    struct Dependency {
        let carNetworkProvider: NetworkProvider
    }
    let view: UIViewController
    let viewModel: CarsListViewModelInputOutput

    init(_ dependency: Dependency) {
        let viewModel = CarsListViewModel(getCarsListUseCase: GetCarsListUseCaseImpl(dependency.carNetworkProvider))
        self.viewModel = viewModel
        let viewController = CarsListViewController(viewModel: viewModel)
        self.view = viewController
    }
}
