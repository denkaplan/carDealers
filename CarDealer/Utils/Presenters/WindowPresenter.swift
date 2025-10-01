//
//  WindowPresenter.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import RxSwift
import UIKit

internal class WindowPresenter: Presenter {
	private var closedSubject: PublishSubject<Void> = .init()
	private var presentedViewControllerSubscription: Disposable?

	let window: UIWindow
	var closed: Observable<Void> {
		closedSubject.asObservable()
	}

	init(window: UIWindow) {
		self.window = window
	}

	func setRootViewController(_ viewController: UIViewController) {
		presentedViewControllerSubscription = viewController.rx.deallocated.bind(to: closedSubject)
		window.rootViewController = viewController
		UIView.transition(
			with: window,
			duration: 0.25,
			options: .transitionCrossDissolve,
			animations: nil,
			completion: nil
		)
		window.makeKeyAndVisible()
	}
}
