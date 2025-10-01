//
//  GetCarsEndpoint.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 23.02.24.
//

import Foundation

struct GetCarsEndpoint: NetworkEndpoint {
    var responseType = [Car].self
    var path: String = "/api/v1/getCars"
    var method: NetworkRequest = .GET
}
