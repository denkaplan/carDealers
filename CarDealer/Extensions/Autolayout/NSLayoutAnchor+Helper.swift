//
//  NSLayoutAnchor+Autolayout.swift
//  JoomPharmacy
//
//  Created by Vladimir Lyseev on 19.10.2020.
//  Copyright © 2020 Joom Pharmacy. All rights reserved.
//

import UIKit

extension NSLayoutAnchor {
    @objc
    func pinned(_ anchor: NSLayoutAnchor) -> NSLayoutConstraint {
        constraint(equalTo: anchor)
    }

    @objc
    func pinned(_ anchor: NSLayoutAnchor, _ const: CGFloat) -> NSLayoutConstraint {
        constraint(equalTo: anchor, constant: const)
    }

    @objc
    func moreThan(_ anchor: NSLayoutAnchor, _ const: CGFloat) -> NSLayoutConstraint {
        constraint(greaterThanOrEqualTo: anchor, constant: const)
    }

    @objc
    func lessThan(_ anchor: NSLayoutAnchor, _ const: CGFloat) -> NSLayoutConstraint {
        constraint(lessThanOrEqualTo: anchor, constant: const)
    }
}
