//
//  CarDetailsCoordinator.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 22.02.24.
//

import UIKit

final class CarDetailsCoordinator: Coordinator<NavigationPresenter, Void> {
    private let dependency: CarDetailsAssembly.Dependency

    init(
        presenter: NavigationPresenter,
        dependency: CarDetailsAssembly.Dependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
    }

    override func start() {
        let assembly = CarDetailsAssembly(dependency)
        presenter.push(assembly.view)
    }
}
