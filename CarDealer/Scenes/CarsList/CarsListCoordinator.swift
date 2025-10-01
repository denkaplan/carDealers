//
//  CarsListCoordinator.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 22.02.24.
//

import RxSwift
import UIKit

final class CarsListCoordinator: Coordinator<EmbeddedPresenter, Void> {
    private let dependency: CarsListAssembly.Dependency
    private let assembly: CarsListAssembly
    private var nc: UINavigationController?

    init(
        presenter: EmbeddedPresenter,
        dependency: CarsListAssembly.Dependency
    ) {
        self.dependency = dependency
        self.assembly = CarsListAssembly(dependency)
        super.init(presenter: presenter)
    }

    deinit {
        print("CarsListCoordinator")
    }

    override func start() {
        let nc = NavigationController()
        nc.viewControllers = [assembly.view]
        presenter.emplace(viewController: nc)
        self.nc = nc

        makeBindings(assembly.viewModel.output)
    }

    private func makeBindings(
        _ output: CarsListViewModelOutput
    ) {
        output.didSelectCar
            .subscribe(onNext: { [weak self] car in
                guard let self else { return }
                self.startDetailsFlow(input: car)
            })
            .disposed(by: bag)
    }

    private func startDetailsFlow(input: CarViewModel) {
        let presenter = NavigationPresenter(navigationController: nc, initialViewController: assembly.view)
        let coordinator = CarDetailsCoordinator(presenter: presenter, dependency: .init(input: input))
        coordinate(to: coordinator)
    }
}
