//
//  ModalNavigationPresenter.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit
import RxSwift

/// Презентер для показа модального экрана с навигацией.
/// Закрывается по закрытию модального экрана.
internal class ModalNavigationPresenter: Presenter {
	private var navigationPresented: Bool = false
	private let internalModalPresenter: ModalPresenter
	private let modalPresentationStyle: UIModalPresentationStyle

	private(set) weak var navigationController: UINavigationController?
	var presentingViewController: UIViewController? {
		internalModalPresenter.presentingViewController
	}
	var closed: Observable<Void> {
		internalModalPresenter.closed
	}

	init(
		from presentingViewController: UIViewController?,
		modalPresentationStyle: UIModalPresentationStyle = .currentContext
	) {
		internalModalPresenter = ModalPresenter(from: presentingViewController)
		self.modalPresentationStyle = modalPresentationStyle
	}

	func push(_ viewController: UIViewController) {
		if navigationPresented {
			guard let navigationController = navigationController else {
				assertionFailure("Нельзя открыть \(viewController) в UINavigationController'е которого уже нет")
				return
			}
			navigationController.pushViewController(viewController, animated: true)
		} else {
			let navigationController = NavigationController(rootViewController: viewController)
			navigationController.modalPresentationStyle = modalPresentationStyle
			internalModalPresenter.present(navigationController)
			self.navigationController = navigationController
			navigationPresented = true
		}
	}

	func pop(to viewController: UIViewController) {
		guard let navigationController = navigationController else {
			assertionFailure("Нельзя вернуться к \(viewController) в UINavigationController'е которого уже нет")
			return
		}
		navigationController.popToViewController(viewController, animated: true)
	}

	func dismiss() {
		internalModalPresenter.dismiss()
	}
}
