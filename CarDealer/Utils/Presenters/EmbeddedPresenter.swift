//
//  EmbeddedPresenter.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit
import RxSwift

/// Презентер для встраивания вью контроллеров в другие вью контроллеры
internal class EmbeddedPresenter: Presenter {
	private let closedSubject = PublishSubject<Void>()
	private weak var containerView: UIView?
	private weak var emplacedViewController: UIViewController?
	private var emplacedViewControllerSubscription: Disposable?

	private(set) weak var containerViewController: UIViewController?
	var closed: Observable<Void> {
		closedSubject.asObservable()
	}

	init(in view: UIView?, of viewController: UIViewController?) {
		self.containerViewController = viewController
		self.containerView = view
	}

	private func displaceCurrentViewController() {
		guard let emplacedViewController = emplacedViewController else { return }

		emplacedViewController.willMove(toParent: nil)
		emplacedViewController.view.removeFromSuperview()
		emplacedViewController.removeFromParent()
	}

	func emplace(viewController: UIViewController) {
		displaceCurrentViewController()

		guard let rootViewController = containerViewController else {
			assertionFailure("Нельзя встроить \(viewController) в контроллер которого уже нет")
			return
		}

		guard let containerView = containerView else {
			assertionFailure("Нельзя встроить \(viewController) во вью которой уже нет")
			return
		}

		rootViewController.addChild(viewController)
		viewController.view.frame = containerView.bounds
		viewController.view.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(viewController.view)
        viewController.view.pin(to: containerView)
		rootViewController.didMove(toParent: rootViewController)

		emplacedViewController = viewController
		emplacedViewControllerSubscription = viewController.rx.deallocated.bind(to: closedSubject)
	}

	func displace() {
		displaceCurrentViewController()
	}
}
