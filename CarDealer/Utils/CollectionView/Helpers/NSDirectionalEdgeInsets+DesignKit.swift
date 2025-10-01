//
//  NSDirectionalEdgeInsets+DesignKit.swift
//  Onfy
//
//  Created by Deniz Kaplan on 23/12/2022.
//

import UIKit

extension NSDirectionalEdgeInsets {
    static var defaultLeading: NSDirectionalEdgeInsets {
        .init(top: 0, leading: 16, bottom: 0, trailing: 0)
    }

    static var largeLeading: NSDirectionalEdgeInsets {
        .init(top: 0, leading: 32, bottom: 0, trailing: 0)
    }

    static var defaultTop: NSDirectionalEdgeInsets {
        .init(top: 16, leading: 0, bottom: 0, trailing: 0)
    }

    static var defaultLeftRight: NSDirectionalEdgeInsets {
        .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    }

    static func padding(_ inset: CGFloat) -> NSDirectionalEdgeInsets {
        .init(top: inset, leading: inset, bottom: inset, trailing: inset)
    }
}

// MARK: Helpers

extension NSDirectionalEdgeInsets {
    var verticalInset: CGFloat { top + bottom }
}
