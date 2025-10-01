//
//  PresentationDelegate.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit

internal class PresentationDelegate: NSObject, UIAdaptivePresentationControllerDelegate {
	let onDismiss: () -> Void

	init(onDismiss: @escaping () -> Void) {
		self.onDismiss = onDismiss
	}

	func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
		onDismiss()
	}
}
