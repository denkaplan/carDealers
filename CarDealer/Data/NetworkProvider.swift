//
//  NetworkProvider.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 23.02.24.
//

import RxRelay
import RxSwift
import RxCocoa
import Foundation

protocol NetworkProvider {
    func execute<T: NetworkEndpoint>(_ endpoint: T) -> Observable<T.Response>
}

struct NetworkResponse<T: Codable> {
    let wrapped: T
    init(wrapped: T) {
        self.wrapped = wrapped
    }
}

protocol NetworkEndpoint {
    associatedtype Response: Codable

    var responseType: Response.Type { get }
    var path: String { get }
    var method: NetworkRequest { get }
}

enum NetworkRequest: String {
    case GET
    case POST
}

enum DefaultErrors: Error {
    case deallocate
    case some
    case http(Int)
}

struct NetworkProviderConfiguration {
    let host: String
}

final class NetworkProviderImpl {

    private let session: URLSession
    private let configuration: NetworkProviderConfiguration
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            if let date = dateFormatter.date(from: dateStr) {
                return date
            }
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            if let date = dateFormatter.date(from: dateStr) {
                return date
            }
            throw DefaultErrors.some
        })
        return decoder
    }()

    init(
        session: URLSession = .shared,
        configuration: NetworkProviderConfiguration
    ) {
        self.session = session
        self.configuration = configuration
    }
}

extension NetworkProviderImpl: NetworkProvider {
    func execute<T>(_ endpoint: T) -> Observable<T.Response> where T : NetworkEndpoint {
        let requestBuilderObservable = Observable<URLRequest>.create { [weak self] observer in
            guard let self else {
                observer.onError(DefaultErrors.deallocate)
                observer.onCompleted()
                return Disposables.create()
            }
            
            guard let request = makeRequest(from: endpoint) else {
                observer.onError(DefaultErrors.deallocate)
                observer.onCompleted()
                return Disposables.create()
            }
            
            observer.onNext(request)
            observer.onCompleted()
            return Disposables.create()
        }

        return requestBuilderObservable
            .flatMap(session.rx.response)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .map { response, data -> (response: HTTPURLResponse, data: Data) in
                if 200 ..< 300 ~= response.statusCode {
                    return (response: response, data: data)
                } else {
                    throw DefaultErrors.deallocate
                }
            }
            .catch { error in
                if case let RxCocoaURLError.httpRequestFailed(response, _) = error {
                    let statusCode = response.statusCode
                    return Observable.error(DefaultErrors.http(statusCode))
                }
                return .error(error)
            }
            .compactMap { [weak self] response, data in
                if let result = try? self?.decoder.decode(endpoint.responseType, from: data) {
                    return result
                }
                return nil 
            }
            .observe(on: MainScheduler.instance)
    }

    private func makeRequest(from endpoint: any NetworkEndpoint) -> URLRequest? {
        var components = URLComponents(string: configuration.host)
        components?.path = endpoint.path
        components?.scheme = "https"
        guard let url = components?.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        return request
    }
}
