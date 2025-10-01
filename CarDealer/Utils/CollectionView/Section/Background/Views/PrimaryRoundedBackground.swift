//
//  PrimaryRoundedBackground.swift
//  Onfy
//
//  Created by Deniz Kaplan on 20/03/2023.
//

import UIKit

final class PrimaryPlainBackground: PrimaryBaseRoundedBackground {
    override init(frame: CGRect) {
        super.init(frame: frame, hasTop: false, hasBottom: false)
    }
}

final class PrimaryRoundedBackground: PrimaryBaseRoundedBackground {
    override init(frame: CGRect) {
        super.init(frame: frame, hasTop: true, hasBottom: true)
    }
}

final class PrimaryTopRoundedBackground: PrimaryBaseRoundedBackground {
    override init(frame: CGRect) {
        super.init(frame: frame, hasTop: true, hasBottom: false)
    }
}

final class PrimaryBottomRoundedBackground: PrimaryBaseRoundedBackground {
    override init(frame: CGRect) {
        super.init(frame: frame, hasTop: false, hasBottom: true)
    }
}

class PrimaryBaseRoundedBackground: UICollectionReusableView {
    class var reuseIdentifier: String {
        String(describing: self)
    }

    private var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(frame: CGRect, hasTop: Bool, hasBottom: Bool) {
        super.init(frame: frame)
        setup(hasTop: hasTop, hasBottom: hasBottom)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private func setup(hasTop: Bool, hasBottom: Bool) {
        backgroundColor = .clear
        addSubview(view)

        var maskedCorners: CACornerMask = []
        if hasTop {
            maskedCorners.formUnion([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        if hasBottom {
            maskedCorners.formUnion([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
        view.layer.maskedCorners = maskedCorners

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: hasBottom ? -8 : 0)
        ])
    }
}
