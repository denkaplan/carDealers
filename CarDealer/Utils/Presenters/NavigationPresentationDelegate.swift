//
//  NavigationPresentationDelegate.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit

internal class NavigationPresentationDelegate: NSObject, UINavigationControllerDelegate {
	private struct NavigationDidShowObserving {
		weak var viewController: UIViewController?
		let onDidShow: () -> Void
	}

    weak var navigationController: UINavigationController?
	private var observings: [NavigationDidShowObserving] = []

	func navigationController(
		_ navigationController: UINavigationController,
		didShow viewController: UIViewController,
		animated: Bool
	) {
        self.navigationController = navigationController
		observings.forEach { observing in
			if observing.viewController == viewController {
				observing.onDidShow()
			}
		}
	}

	func addObserverOnDidShow(of viewController: UIViewController, action: @escaping () -> Void) {
		observings.append(NavigationDidShowObserving(viewController: viewController, onDidShow: action))
	}
}
