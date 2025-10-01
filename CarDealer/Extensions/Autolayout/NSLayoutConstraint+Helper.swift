//
//  NSLayoutConstraint+Helper.swift
//  Onfy
//
//  Created by Vladimir Lyseev on 18.07.2022.
//  Copyright © 2022 Joom Pharmacy. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
