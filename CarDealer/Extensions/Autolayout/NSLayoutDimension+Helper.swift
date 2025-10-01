//
//  NSLayoutDimension+Helper.swift
//  JoomPharmacy
//
//  Created by Vladimir Lyseev on 19.10.2020.
//  Copyright © 2020 Joom Pharmacy. All rights reserved.
//

import UIKit

extension NSLayoutDimension {
    @objc
    func withValue(_ constant: CGFloat) -> NSLayoutConstraint {
        constraint(equalToConstant: constant)
    }

    @objc
    func equal(_ anchor: NSLayoutAnchor<NSLayoutDimension>) -> NSLayoutConstraint {
        constraint(equalTo: anchor)
    }

    @objc
    func equal(_ anchor: NSLayoutDimension, multiplier: CGFloat) -> NSLayoutConstraint {
        constraint(equalTo: anchor, multiplier: multiplier)
    }

    @objc
    func equal(_ anchor: NSLayoutDimension, _ const: CGFloat) -> NSLayoutConstraint {
        constraint(equalTo: anchor, constant: const)
    }
}
