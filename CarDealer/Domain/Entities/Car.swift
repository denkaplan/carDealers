//
//  Car.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 25.02.24.
//

import Foundation

struct Car: Codable {
    let thumbImage: URL
    let year: Date
    let price: String
    let model: String
    let brand: String
    let fuel: String
    let currency: String
}
