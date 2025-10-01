//
//  SectionLayout.TableConfiguration.swift
//  Onfy
//
//  Created by Deniz Kaplan on 13/01/2023.
//

import UIKit

extension SectionLayout {
    /// Configuration of Table Layout
    struct TableConfiguration {
        let style: Style
    }
}

// MARK: Nested Types

extension SectionLayout.TableConfiguration {
    enum Style {
        case rounded(CGFloat)
        case plain
    }

    static func plain() -> Self {
        .init(style: .plain)
    }

    static func rounded(_ cornerRadius: CGFloat) -> Self {
        .init(style: .rounded(cornerRadius))
    }
}
