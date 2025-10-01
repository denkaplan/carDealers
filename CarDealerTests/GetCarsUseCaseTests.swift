//
//  GetCarsUseCaseTests.swift
//  CarDealerTests
//
//  Created by Deniz Kaplan on 24.02.24.
//

import RxTest
import RxBlocking
import RxSwift
import XCTest
@testable import CarDealer

final class GetCarsListUseCaseTests: XCTestCase {

    var sut: GetCarsListUseCase!
    var networkProviderMock: NetworkProviderMock!

    override func setUp() async throws {
        networkProviderMock = NetworkProviderMock()
        sut = GetCarsListUseCaseImpl(networkProviderMock)
    }

    override func tearDown() async throws {
        networkProviderMock = nil
        sut = nil
    }

    private var bag = DisposeBag()

    func testGetCarsViewModel() throws {
        // arrange
        networkProviderMock.throwError = false

        // act
        let result = try sut.execute()
            .toBlocking()
            .first()?
            .first

        // assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.model, "100")
        XCTAssertEqual(result!.priceString, "0 A")
        XCTAssertEqual(result!.fuel, "1")
        XCTAssertEqual(result!.brand, "1")
    }

    func testGetCarsFailure() throws {
        // arrange
        networkProviderMock.throwError = true

        // act
        let result = try sut.execute()
            .toBlocking()
            .first()

        // assert
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.isEmpty)
    }
}

extension GetCarsListUseCaseTests {
    final class NetworkProviderMock: NetworkProvider {

        var throwError: Bool = false

        var response: [Car] = [
            Car(
                thumbImage: URL(string: "testUrl")!,
                year: Date(),
                price: "0",
                model: "100",
                brand: "1",
                fuel: "1",
                currency: "A")
        ]

        func execute<T>(_ endpoint: T) -> RxSwift.Observable<T.Response> where T : CarDealer.NetworkEndpoint {
            if throwError {
                return Observable.error(DefaultErrors.some)
            }
            return .just(response as! T.Response)
        }
    }
}
