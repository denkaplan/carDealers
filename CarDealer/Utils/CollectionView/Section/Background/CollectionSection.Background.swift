//
//  CollectionSection.Background.swift
//  Onfy
//
//  Created by Deniz Kaplan on 20/03/2023.
//

import UIKit

extension CollectionSection {
    enum Background {
        case primaryPlain
        case primaryRounded
        case primaryRoundedTop
        case primaryRoundedBottom

        var viewClass: AnyClass {
            switch self {
            case .primaryPlain: return PrimaryPlainBackground.self
            case .primaryRounded: return PrimaryRoundedBackground.self
            case .primaryRoundedTop: return PrimaryTopRoundedBackground.self
            case .primaryRoundedBottom: return PrimaryBottomRoundedBackground.self
            }
        }

        var reuseIdentifier: String {
            switch self {
            case .primaryPlain: return PrimaryPlainBackground.reuseIdentifier
            case .primaryRounded: return PrimaryRoundedBackground.reuseIdentifier
            case .primaryRoundedTop: return PrimaryTopRoundedBackground.reuseIdentifier
            case .primaryRoundedBottom: return PrimaryBottomRoundedBackground.reuseIdentifier
            }
        }
    }
}
