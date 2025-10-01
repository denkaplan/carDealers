//
//  ModalPresenter.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit
import RxSwift
import RxRelay

/// Презентер для показа модального экрана.
internal class ModalPresenter: Presenter {
	private let dismissRelay = PublishRelay<Void>()
	private lazy var presentationDelegateObject: PresentationDelegate = {
		PresentationDelegate { [weak self] in
			self?.dismissRelay.accept(())
		}
	}()

	private(set) weak var presentingViewController: UIViewController?
	private(set) weak var presentedViewController: UIViewController?

	var closed: Observable<Void> {
		dismissRelay.asObservable()
	}

	init(from presentingViewController: UIViewController?) {
		self.presentingViewController = presentingViewController
	}

	func present(_ viewController: UIViewController) {
		guard let rootViewController = presentingViewController else {
			assertionFailure("Нельзя открыть \(viewController) в контроллере которого уже нет")
			return
		}
		presentedViewController = viewController
		rootViewController.present(viewController, animated: true, completion: nil)
		viewController.presentationController?.delegate = presentationDelegateObject
	}

	func dismiss() {
		presentedViewController?.dismiss(animated: true, completion: nil)
		dismissRelay.accept(())
	}
}
