//
//  CustomModalPresentable.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import UIKit

internal protocol CustomModalPresentable: UIViewController {
	var dismissalHandlingScrollView: UIScrollView? { get }
	var disableCloseGesture: Bool { get }
}
