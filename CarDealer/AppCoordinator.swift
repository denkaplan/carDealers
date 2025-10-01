//
//  AppCoordinator.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit
import RxSwift

internal class AppCoordinator: Coordinator<WindowPresenter, Void> {
    private let rootViewController: UIViewController = {
        let viewController = UIViewController()
        return viewController
    }()

    struct Dependencies {

    }

    private let container: Dependencies
    private let disposeBag = DisposeBag()

    init(
        presenter: WindowPresenter,
        container: Dependencies
    ) {
        self.container = container
        super.init(presenter: presenter)
    }

    override func start() {
        presenter.setRootViewController(rootViewController)
        let presenter = EmbeddedPresenter(in: rootViewController.view, of: rootViewController)
        coordinate(
            to: CarsListCoordinator(
                presenter: presenter,
                dependency: .init(carNetworkProvider: NetworkProviderImpl(configuration: .init(host: "https://65d8a21bc96fbb24c1bbf74a.mockapi.io")))
            )
        )
    }
}
