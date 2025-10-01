//
//  StandardInteractionController.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit

internal final class StandardInteractionController: NSObject, InteractionController, UIGestureRecognizerDelegate {
	private enum Constants {
		static let velocityToDismiss: CGFloat = 600
		static let offsetToDismiss: CGFloat = 0.5
	}

	// MARK: - Private Properties

	private weak var viewController: CustomModalPresentable?
	private weak var transitionContext: UIViewControllerContextTransitioning?

	private var interactionDistance: CGFloat = 0
	private var interruptedTranslation: CGFloat = 0
	private var presentedFrame: CGRect?
	private var cancellationAnimator: UIViewPropertyAnimator?

	private var dismissalHandlingScrollView: UIScrollView? {
		viewController?.dismissalHandlingScrollView
	}
	private var disableCloseGesture: Bool {
		viewController?.disableCloseGesture ?? false
	}

	// MARK: - Public Properties

	var interactionInProgress = false

	// MARK: - Init

	init(viewController: CustomModalPresentable) {
		self.viewController = viewController
		super.init()
		prepareGestureRecognizer(in: viewController.view)
		resolveScrollViewGestures()
	}

	// MARK: - Setup Gestures

	private func prepareGestureRecognizer(in view: UIView) {
		let gesture = OneWayPanGestureRecognizer(target: self, action: #selector(handlePan))
		gesture.delegate = self
		view.addGestureRecognizer(gesture)
	}

	private func resolveScrollViewGestures() {
		guard let scrollView = dismissalHandlingScrollView else {
			return
		}

		let scrollGestureRecognizer = OneWayPanGestureRecognizer(target: self, action: #selector(handlePan))
		scrollGestureRecognizer.delegate = self

		scrollView.addGestureRecognizer(scrollGestureRecognizer)
		scrollView.panGestureRecognizer.require(toFail: scrollGestureRecognizer)
	}

	// MARK: - UIGestureRecognizerDelegate

	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard !disableCloseGesture else { return false }

		if let scrollView = dismissalHandlingScrollView, gestureRecognizer.view == scrollView {
			return (scrollView.contentOffset.y + scrollView.adjustedContentInset.top) <= 0
		}
		return true
	}

	// MARK: - Gesture Handling

	@objc
	private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
		guard let superview = gestureRecognizer.view?.superview else { return }

		let translation = gestureRecognizer.translation(in: superview).y
		let velocity = gestureRecognizer.velocity(in: superview).y

		switch gestureRecognizer.state {
		case .began:
			gestureBegan()
		case .changed:
			gestureChanged(translation: translation + interruptedTranslation, velocity: velocity)
		case .cancelled:
			gestureCancelled(translation: translation + interruptedTranslation, velocity: velocity)
		case .ended:
			gestureEnded(translation: translation + interruptedTranslation, velocity: velocity)
		default:
			break
		}
	}

	private func gestureBegan() {
		guard let viewController = viewController else { return }

		disableOtherTouches()
		cancellationAnimator?.stopAnimation(true)

		if let presentedFrame = presentedFrame {
			interruptedTranslation = viewController.view.frame.minY - presentedFrame.minY
		}

		if !interactionInProgress {
			interactionInProgress = true
			viewController.dismiss(animated: true)
		}
	}

	private func gestureChanged(translation: CGFloat, velocity: CGFloat) {
		let progress = interactionDistance == 0 ? 0 : max(0, translation / interactionDistance)
		update(progress: progress)
	}

	private func gestureCancelled(translation: CGFloat, velocity: CGFloat) {
		cancel(initialSpringVelocity: springVelocity(distanceToTravel: -translation, gestureVelocity: velocity))
	}

	private func gestureEnded(translation: CGFloat, velocity: CGFloat) {
		let enoughVelocity = velocity > Constants.velocityToDismiss
		let enoughOffsetForDismiss = translation > interactionDistance * Constants.offsetToDismiss
			&& velocity > -Constants.velocityToDismiss
		if enoughVelocity || enoughOffsetForDismiss {
			let initialSpringVelocity = springVelocity(
				distanceToTravel: interactionDistance - translation,
				gestureVelocity: velocity
			)
			finish(initialSpringVelocity: initialSpringVelocity)
		} else {
			let initialSpringVelocity = springVelocity(distanceToTravel: -translation, gestureVelocity: velocity)
			cancel(initialSpringVelocity: initialSpringVelocity)
		}
	}

	private func update(progress: CGFloat) {
		guard
			let transitionContext = transitionContext,
			let presentedFrame = presentedFrame
		else {
			return
		}

		transitionContext.updateInteractiveTransition(progress)

		viewController?.view.frame = CGRect(
			x: presentedFrame.minX,
			y: presentedFrame.minY + interactionDistance * progress,
			width: presentedFrame.width,
			height: presentedFrame.height
		)
	}

	private func cancel(initialSpringVelocity: CGFloat) {
		guard
			let transitionContext = transitionContext,
			let presentedFrame = presentedFrame
		else { return }

		let timingParameters = UISpringTimingParameters(
			dampingRatio: 0.8,
			initialVelocity: CGVector(dx: 0, dy: initialSpringVelocity)
		)
		cancellationAnimator = UIViewPropertyAnimator(duration: 0.5, timingParameters: timingParameters)

		cancellationAnimator?.addAnimations { [viewController] in
			viewController?.view.frame = presentedFrame
		}
		cancellationAnimator?.addCompletion { _ in
			transitionContext.cancelInteractiveTransition()
			transitionContext.completeTransition(false)
			self.interactionInProgress = false
			self.enableOtherTouches()
		}
		cancellationAnimator?.startAnimation()
	}

	private func finish(initialSpringVelocity: CGFloat) {
		guard
			let transitionContext = transitionContext,
			let presentedFrame = presentedFrame
		else {
			return
		}

		let dismissedFrame = CGRect(
			x: presentedFrame.minX,
			y: transitionContext.containerView.bounds.height,
			width: presentedFrame.width,
			height: presentedFrame.height
		)
		let timingParameters = UISpringTimingParameters(
			dampingRatio: 0.8,
			initialVelocity: CGVector(dx: 0, dy: initialSpringVelocity)
		)
		let finishAnimator = UIViewPropertyAnimator(duration: 0.5, timingParameters: timingParameters)

		finishAnimator.addAnimations { [viewController] in
			viewController?.view.frame = dismissedFrame
		}
		finishAnimator.addCompletion { _ in
			transitionContext.finishInteractiveTransition()
			transitionContext.completeTransition(true)
			self.interactionInProgress = false
		}
		finishAnimator.startAnimation()
	}

	// MARK: - UIViewControllerInteractiveTransitioning

	func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
		guard let presentedViewController = transitionContext.viewController(forKey: .from) else { return }

		self.transitionContext = transitionContext
		presentedFrame = transitionContext.finalFrame(for: presentedViewController)
		interactionDistance = transitionContext.containerView.bounds.height - (presentedFrame?.minY ?? 0.0)
	}

	// MARK: - Helpers

	private func springVelocity(distanceToTravel: CGFloat, gestureVelocity: CGFloat) -> CGFloat {
		distanceToTravel == 0 ? 0 : gestureVelocity / distanceToTravel
	}

	private func disableOtherTouches() {
		viewController?.view.subviews.forEach {
			$0.isUserInteractionEnabled = false
		}
	}

	private func enableOtherTouches() {
		viewController?.view.subviews.forEach {
			$0.isUserInteractionEnabled = true
		}
	}
}
