//
//  Presenter.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 19.02.24.
//

import RxSwift

/// Протокол для презентера
/// Презентер отвечает за навигацию и показ экранов.
/// При закрытии всех экранов презентер должен отправить событие в `closed`
internal protocol Presenter {
	/// Событие о закрытии всех экранов
	var closed: Observable<Void> { get }
}
