//
//  NavigationPresenter.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit
import RxSwift
import RxCocoa

/// Презентер для показа экранов в уже существующем стеке навигации
/// Закрывается по возвращению стека к начальному вью контроллеру если он был.
/// Если применимо на пустой навигейшн, то не закрывается никогда.
internal class NavigationPresenter: Presenter {
	private let closedRelay = PublishRelay<Void>()
	private let presentationDelegateObject: NavigationPresentationDelegate

	private(set) weak var navigationController: UINavigationController?
	weak var initialViewController: UIViewController?
	var closed: Observable<Void> {
		closedRelay.asObservable()
	}

	convenience init(in navigationController: UINavigationController?) {
		self.init(
			navigationController: navigationController,
			initialViewController: navigationController?.topViewController
		)
	}

	init(navigationController: UINavigationController?, initialViewController: UIViewController?) {
		self.navigationController = navigationController
		self.initialViewController = initialViewController
		if let navigationDelegate = navigationController?.delegate {
			if let presentationDelegate = navigationDelegate as? NavigationPresentationDelegate {
				presentationDelegateObject = presentationDelegate
			} else {
				presentationDelegateObject = NavigationPresentationDelegate()
				assertionFailure(
					"""
					NavigationPresenter заменил delegate у \(String(describing: navigationController)). \
					Это значит что этот NavigationPresenter был использован на UINavigationController'е \
					у которого кем то уже был установлен другой делегат и теперь вся логика \
					зависимая от этого делегата сломалась.
					"""
				)
			}
		} else {
			presentationDelegateObject = NavigationPresentationDelegate()
		}

		navigationController?.delegate = presentationDelegateObject

		if let initialViewController = initialViewController {
			presentationDelegateObject.addObserverOnDidShow(of: initialViewController) { [weak self] in
				self?.closedRelay.accept(())
			}
		}
	}

	func push(_ viewController: UIViewController) {
		guard let navigationController = navigationController else {
			assertionFailure("Нельзя открыть \(viewController) в UINavigationController'е которого уже нет")
			return
		}

		navigationController.pushViewController(viewController, animated: true)
	}

	func pop() {
		guard let navigationController = navigationController else {
			assertionFailure("Нельзя вернуться в UINavigationController'е которого уже нет")
			return
		}

		navigationController.popViewController(animated: true)
	}

	func pop(to viewController: UIViewController) {
		guard let navigationController = navigationController else {
			assertionFailure("Нельзя вернуться к \(viewController) в UINavigationController'е которого уже нет")
			return
		}

		navigationController.popToViewController(viewController, animated: true)
	}

	func popToInitialViewController() {
		guard let initialViewController = initialViewController else {
			assertionFailure("Нельзя вернуться к начальному экрану т.к. его нет")
			return
		}

		navigationController?.popToViewController(initialViewController, animated: true)
	}
}
