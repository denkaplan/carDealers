//
//  ModalPresentationController.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit

internal final class ModalPresentationController: UIPresentationController {
	private let dimmingView = UIView()

	override func presentationTransitionWillBegin() {
		guard let containerBounds = containerView?.bounds else { return }

		dimmingView.backgroundColor = .black
		dimmingView.frame = containerBounds
		dimmingView.alpha = 0
		containerView?.insertSubview(dimmingView, at: 0)

		presentedViewController.transitionCoordinator?.animate(
			alongsideTransition: { [dimmingView] _ in
				dimmingView.alpha = 0.5
			}
		)
	}

	override func dismissalTransitionWillBegin() {
		presentedViewController.transitionCoordinator?.animate(
			alongsideTransition: { [dimmingView] _ in
				dimmingView.alpha = 0
			}
		)
	}

	override func dismissalTransitionDidEnd(_ completed: Bool) {
		guard completed else { return }

		if #available(iOS 13, *) {
			delegate?.presentationControllerDidDismiss?(self)
		} else {
			(delegate as? PresentationDelegate)?.presentationControllerDidDismiss(self)
		}
	}
}
