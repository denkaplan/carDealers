//
//  UIView+Autolayout.swift
//  JoomPharmacy
//
//  Created by Vladimir Lyseev on 19.10.2020.
//  Copyright © 2020 Joom Pharmacy. All rights reserved.
//

import UIKit

extension UIView {
    var top: NSLayoutYAxisAnchor {
        topAnchor
    }

    var bottom: NSLayoutYAxisAnchor {
        bottomAnchor
    }

    var left: NSLayoutXAxisAnchor {
        leadingAnchor
    }

    var right: NSLayoutXAxisAnchor {
        trailingAnchor
    }

    var centerX: NSLayoutXAxisAnchor {
        centerXAnchor
    }

    var centerY: NSLayoutYAxisAnchor {
        centerYAnchor
    }

    var width: NSLayoutDimension {
        widthAnchor
    }

    var height: NSLayoutDimension {
        heightAnchor
    }

    var firstBaseline: NSLayoutYAxisAnchor {
        firstBaselineAnchor
    }

    var lastBaseline: NSLayoutYAxisAnchor {
        lastBaselineAnchor
    }

    @discardableResult
    func pin(to view: UIView) -> [NSLayoutConstraint] {
        let constraints = [
            top.pinned(view.top),
            left.pinned(view.left),
            right.pinned(view.right),
            bottom.pinned(view.bottom)
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
