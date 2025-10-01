//
//  ModalTransitionDelegate.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit

internal final class ModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
	private var interactionController: InteractionController?

	init(interactionController: InteractionController?) {
		self.interactionController = interactionController
	}

	func presentationController(
		forPresented presented: UIViewController,
		presenting: UIViewController?,
		source: UIViewController
	) -> UIPresentationController? {
		ModalPresentationController(presentedViewController: presented, presenting: presenting)
	}

	func animationController(
		forPresented presented: UIViewController,
		presenting: UIViewController,
		source: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		ModalTransitionAnimator(presenting: true)
	}

	func animationController(
		forDismissed dismissed: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		ModalTransitionAnimator(presenting: false)
	}

	func interactionControllerForDismissal(
		using animator: UIViewControllerAnimatedTransitioning
	) -> UIViewControllerInteractiveTransitioning? {
		guard
			let interactionController = interactionController,
			interactionController.interactionInProgress
		else {
			return nil
		}
		return interactionController
	}
}
