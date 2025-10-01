//
//  NavigationController.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 23.02.24.
//

import UIKit

final class NavigationController: UINavigationController {
    init() {
        super.init(navigationBarClass: UINavigationBar.self, toolbarClass: nil)
    }

    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: UINavigationBar.self, toolbarClass: nil)
        self.viewControllers = [rootViewController]
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
        setupUI()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        visibleViewController?.preferredStatusBarStyle ?? .default
    }

    override var childForStatusBarStyle: UIViewController? {
        visibleViewController
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }

    // MARK: Setup

    func setupUI() {
        additionalSafeAreaInsets.top = 6
        setToolbarHidden(true, animated: false)
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == navigationController?.interactivePopGestureRecognizer else {
            return true // default value
        }
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
