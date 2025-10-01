//
//  InteractionController.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit

internal protocol InteractionController: UIViewControllerInteractiveTransitioning {
	var interactionInProgress: Bool { get }
}
