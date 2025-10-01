//
//  ObservableType+Ext.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 23.02.24.
//

import RxSwift
import RxCocoa

extension ObservableType {
	func catchErrorJustComplete() -> Observable<Element> {
		self.catch { _ in
			Observable.empty()
		}
	}

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

	func mapToVoid() -> Observable<Void> {
		map { _ in }
	}

	func withPrevious() -> Observable<(previous: Element?, current: Element)> {
		let tuple: (previous: Element?, current: Element?) = (nil, nil)

		return scan(tuple) { accumulator, current in
			(previous: accumulator.current, current: current)
		}
		.compactMap {
			guard let current = $0.current else { return nil }
			return ($0.previous, current)
		}
	}
}
