//
//  GetCarsListUseCase.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 23.02.24.
//

import RxRelay
import RxSwift
import Foundation

protocol GetCarsListUseCase {
    func execute() -> Observable<[CarViewModel]>
}

final class GetCarsListUseCaseImpl: GetCarsListUseCase {
    private let networkProvider: NetworkProvider

    init(_ networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    func execute() -> Observable<[CarViewModel]> {
        networkProvider.execute(
            GetCarsEndpoint()
        )
        .catchAndReturn([])
        .map {
            $0.map {
                CarViewModel($0)
            }
        }
    }
}
