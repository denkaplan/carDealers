//
//  Pallete.swift
//  CarDealer
//
//  Created by Deniz Kaplan on 22.02.24.
//

import UIKit

enum Pallete {
    static var backgroudPrimary: UIColor {
        .systemBackground
    }

    static var onsurfacePrimary: UIColor {
        UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return .white
            }
            return .black
        }
    }

    static var onsurfaceSecondary: UIColor {
        .secondaryLabel
    }
}
