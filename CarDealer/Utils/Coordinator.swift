//
//  Coordinator.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import Foundation
import RxSwift

internal class Coordinator<SomePresenter: Presenter, FlowOutput> {
	let presenter: SomePresenter
	let bag = DisposeBag()
	let identifier = UUID()

	private var childCoordinators: [UUID: Any] = [:]

	init(presenter: SomePresenter) {
		self.presenter = presenter
	}

	@discardableResult
	func start() -> FlowOutput? {
		assertionFailure("Метод start не реализован у \(String(describing: self))")
		return nil
	}

	@discardableResult
	func coordinate<P, O>(to anotherCoordinator: Coordinator<P, O>) -> O? {
		let identifier = anotherCoordinator.identifier
		childCoordinators[identifier] = anotherCoordinator

		anotherCoordinator
            .presenter
            .closed
            .asDriverOnErrorJustComplete()
			.drive(
				onNext: { [weak self, identifier] in
					self?.childCoordinators[identifier] = nil
				}
			)
			.disposed(by: bag)

		return anotherCoordinator.start()
	}
}
