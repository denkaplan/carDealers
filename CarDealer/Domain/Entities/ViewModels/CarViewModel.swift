//
//  CarViewModel.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 23.02.24.
//

import UIKit

struct CarViewModel {
    let brand: String
    let model: String
    let yearString: String
    let fuel: String
    let image: Image
    let priceString: String

    init(_ car: Car) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"

        self.brand = car.brand
        self.image = .init(url: car.thumbImage)
        self.model = car.model
        self.yearString = dateFormatter.string(from: car.year)
        self.fuel = car.fuel
        self.priceString = car.price + " " + car.currency
    }

    func contains(_ string: String) -> Bool {
        let string = string.lowercased()

        if model.lowercased().contains(string) {
            return true
        }

        if brand.lowercased().contains(string) {
            return true
        }

        return false
    }
}
