//
//  PrimitiveSequence+Ext.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 23.02.24.
//

import Foundation
import RxSwift
import RxCocoa

internal extension PrimitiveSequence {
	func asDriverOnErrorJustComplete() -> Driver<Element> {
		asDriver { _ in
			Driver.empty()
		}
	}

	func asSignalOnErrorJustComplete() -> Signal<Element> {
		asSignal { _ in
			Signal.empty()
		}
	}
}
